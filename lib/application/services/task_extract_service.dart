import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';

class TaskDraft {
  final String title; //タスク名
  final String? note; // 補足説明
  final String? due; // ISO8601日付 (例: 2025-08-15) or null
  final String? priority; //優先度 'low' | 'normal' | 'high'

  TaskDraft({required this.title, this.note, this.due, this.priority});

  factory TaskDraft.fromMap(Map<String, dynamic> m) => TaskDraft(
        title: m['title'] as String,
        note: m['note'] as String?,
        due: m['due'] as String?,
        priority: m['priority'] as String?,
      );
}

/// A failure while communicating with Gemini or parsing the response.
class TaskExtractionException implements Exception {
  TaskExtractionException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() {
    final buffer = StringBuffer('TaskExtractionException: $message');
    if (cause != null) {
      buffer.write(' (cause: $cause)');
    }
    return buffer.toString();
  }
}

typedef GeminiTaskRequest = Future<String?> Function({
  required String prompt,
  required GenerationConfig config,
});

class TaskExtractService {
  TaskExtractService(GenerativeModel model)
      : this._(
          request: ({required prompt, required config}) async {
            final response = await model.generateContent(
              [Content.text(prompt)],
              generationConfig: config,
            );
            return response.text;
          },
        );

  TaskExtractService._({
    required GeminiTaskRequest request,
    DateTime Function()? clock,
  })  : _request = request,
        _clock = clock ?? DateTime.now;

  @visibleForTesting
  factory TaskExtractService.test({
    required GeminiTaskRequest request,
    DateTime Function()? clock,
  }) {
    return TaskExtractService._(request: request, clock: clock);
  }

  final GeminiTaskRequest _request;
  final DateTime Function() _clock;

  /// 長文からタスク配列を抽出
  Future<List<TaskDraft>> splitTasks(String input) async {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return const [];
    }

    // 日本時間の現在年を取得
    final jstNow = _clock().toUtc().add(const Duration(hours: 9));
    final currentYear = jstNow.year;

    // 出力スキーマ（タスクの配列をトップレベルに）
    final taskSchema = Schema.array(
      items: Schema.object(
        properties: {
          'title': Schema.string(description: '短い命令形のタスク名'),
          'note': Schema.string(description: '補足メモ', nullable: true),
          'due': Schema.string(description: 'YYYY-MM-DD 形式の期日', nullable: true),
          'priority': Schema.enumString(
            enumValues: ['low', 'normal', 'high'],
            description: '優先度',
          ),
        },
        requiredProperties: ['title'],
      ),
    );

    final generationConfig = GenerationConfig(
      responseMimeType: 'application/json', // jsonで返す
      responseSchema: taskSchema,
      maxOutputTokens: 1024,
      temperature: 0.2, // この値で文章の安定性を設定（0.0～1.0）0に近いほど安定
    );

    // プロンプト内容
    final prompt = '''
あなたは日本語のタスク抽出器。以下の文章から「実行可能なToDo」を最小単位に分割して出力する。
- 出力はJSONのみ（配列）。説明文や前置きは絶対に含めない。
- 各要素は {title, note?, due?, priority?}。
- titleは5〜30文字程度の命令形。絵文字や番号は不要。
- dueは分かる場合のみ "YYYY-MM-DD"（日本時間）で。
- 年が書かれていない日付は $currentYear 年として解釈する（日本時間）。
- priorityは推定して low/normal/high のいずれか。
入力:
$trimmed
''';

    try {
      final raw = await _request(
        prompt: prompt,
        config: generationConfig,
      );

      final normalized = _normalizeResponse(raw);

      if (normalized == null || normalized.isEmpty) {
        return const [];
      }

      final decoded = json.decode(normalized) as Object;
      if (decoded is! List) {
        throw const FormatException('Expected the response to be a JSON array.');
      }

      return decoded.map<TaskDraft>((item) {
        if (item is! Map) {
          throw const FormatException('Each task must be represented as a JSON object.');
        }
        return TaskDraft.fromMap(Map<String, dynamic>.from(item));
      }).toList();
    } on TaskExtractionException {
      rethrow;
    } on GenerativeAIException catch (e) {
      throw TaskExtractionException('Gemini APIの呼び出しに失敗しました。APIキーと権限を確認してください。', e);
    } on FormatException catch (e) {
      throw TaskExtractionException('Geminiのレスポンスを解析できませんでした。', e);
    } on TypeError catch (e) {
      throw TaskExtractionException('Geminiのレスポンスの形式が不正です。', e);
    } catch (e) {
      throw TaskExtractionException('タスク抽出処理で予期しないエラーが発生しました。', e);
    }
  }

  /// Strips Gemini specific wrappers (e.g. fenced code blocks) and
  /// extracts the JSON array string. Returns `null` when [raw] itself is
  /// `null` or only contains whitespace.
  @visibleForTesting
  String? _normalizeResponse(String? raw) {
    if (raw == null) {
      return null;
    }

    String trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    final fence = RegExp(r'^```(?:json)?\s*([\s\S]*?)```\s*$', multiLine: true);
    final fenceMatch = fence.firstMatch(trimmed);
    if (fenceMatch != null) {
      trimmed = fenceMatch.group(1)!.trim();
    }

    // If Gemini still wraps the payload with explanatory text, attempt to
    // pick the outermost JSON array.
    final start = trimmed.indexOf('[');
    final end = trimmed.lastIndexOf(']');
    if (start != -1 && end != -1 && end > start) {
      final candidate = trimmed.substring(start, end + 1).trim();
      if (candidate.isNotEmpty) {
        return candidate;
      }
    }

    return trimmed;
  }
}
