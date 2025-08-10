import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

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

class TaskExtractService {
  final GenerativeModel _model;
  TaskExtractService(this._model);

  /// 長文からタスク配列を抽出
  Future<List<TaskDraft>> splitTasks(String input) async {
    // 日本時間の現在年を取得
    final jstNow = DateTime.now().toUtc().add(const Duration(hours: 9));
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
$input
''';

    //プロンプトを投げ、結果を受け取る
    final res = await _model.generateContent([
      Content.text(prompt),
    ], generationConfig: generationConfig);

    final raw = res.text ?? '[]';
    //json文字列をデコードして、List<Map<String, dynamic>>に変換
    final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();
    //List<TaskDraft>を返す
    return list.map(TaskDraft.fromMap).toList();
  }
}
