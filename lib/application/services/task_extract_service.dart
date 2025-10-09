import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class TaskDraft {
  final String title;
  final String? note;
  final String? due;
  final String? priority;

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

  Future<List<TaskDraft>> splitTasks(String input) async {
    final prompt = '''
あなたは日本語のタスク抽出器。以下の文章から実行可能なToDoを最小単位に分割して出力する。
必須ルール:
- 出力は **配列のJSONのみ**。前置き・文章・コードブロック( ``` や ```json ) を一切含めない。
- 各要素は { "title": string, "note"?: string, "due"?: "YYYY-MM-DD", "priority"?: "low"|"normal"|"high" }。
- titleは命令形・5〜30文字・絵文字や番号なし。
- dueは分かるときのみ日本時間で "YYYY-MM-DD"。
- priorityは推定して low / normal / high のいずれか。
入力:
$input
''';

    final cfg = GenerationConfig(temperature: 0.2, maxOutputTokens: 1024);

    final res = await _model.generateContent([
      Content.text(prompt),
    ], generationConfig: cfg);

    final raw = res.text ?? '[]';
    final parsed = _safeJsonDecode(raw);
    if (parsed is! List) return [];
    return parsed
        .whereType<Map<String, dynamic>>()
        .map(TaskDraft.fromMap)
        .toList();
  }

  // --- ここからJSON抽出ヘルパ ---
  dynamic _safeJsonDecode(String raw) {
    var s = raw.trim();

    // 1) ```json ... ``` or ``` ... ``` を優先的に剥がす
    final fenced = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```', multiLine: true);
    final m = fenced.firstMatch(s);
    if (m != null) s = m.group(1)!.trim();

    // 2) 先頭に json や言い訳が付いていたら除去
    s = s.replaceFirst(RegExp(r'^\s*json\s*', caseSensitive: false), '').trim();

    // 3) まずは素直にデコード
    try {
      return jsonDecode(s);
    } catch (_) {
      // 4) 文章に埋もれている場合、最初の [ or { から対応カッコまでを抜き出す
      final start = s.indexOf(RegExp(r'[\[\{]'));
      if (start == -1) throw const FormatException('No JSON found');
      final end = _matchingBracketEnd(s, start);
      if (end == -1) throw const FormatException('Unbalanced JSON');
      final sub = s.substring(start, end);
      return jsonDecode(sub);
    }
  }

  int _matchingBracketEnd(String s, int start) {
    final open = s[start];
    final close = (open == '[') ? ']' : '}';
    var depth = 0;
    var inString = false;

    for (var i = start; i < s.length; i++) {
      final ch = s[i];

      if (ch == '"' && (i == 0 || s[i - 1] != '\\')) {
        inString = !inString;
      }
      if (inString) continue;

      if (ch == open) depth++;
      if (ch == close) {
        depth--;
        if (depth == 0) return i + 1;
      }
    }
    return -1;
  }
}
