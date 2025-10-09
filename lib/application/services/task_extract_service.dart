import 'dart:convert';
import 'package:next_todo/application/services/gemini_client.dart';

class TaskDraft {
  final String title; //タスク名
  final String? note; // 補足説明
  final String? due; // YYYY-MM-DD
  final String? priority; // 'low' | 'normal' | 'high'

  TaskDraft({required this.title, this.note, this.due, this.priority});

  factory TaskDraft.fromMap(Map<String, dynamic> m) => TaskDraft(
    title: m['title'] as String,
    note: m['note'] as String?,
    due: m['due'] as String?,
    priority: m['priority'] as String?,
  );
}

class TaskExtractService {
  final GeminiClient _gemini; // ← ここを GenerativeModel から変更
  TaskExtractService(this._gemini);

  /// 長文からタスク配列を抽出
  Future<List<TaskDraft>> splitTasks(String input) async {
    // 日本時間の現在年
    final jstNow = DateTime.now().toUtc().add(const Duration(hours: 9));
    final currentYear = jstNow.year;

    // プロンプト
    final prompt = '''
あなたは日本語のタスク抽出器。以下の文章から「実行可能なToDo」を最小単位に分割して**JSON配列のみ**で出力する。
配列の各要素は { "title": string, "note"?: string, "due"?: "YYYY-MM-DD", "priority"?: "low"|"normal"|"high" }。
**説明文やコードフェンスや余計な文字は一切含めない**。空配列のときは [] だけを返す。
- titleは5〜30文字程度の命令形。絵文字や番号は不要。
- dueは分かる場合のみ（日本時間）。年が無ければ $currentYear 年として解釈。
入力:
$input
''';

    // Worker経由で生成
    final raw = await _gemini.generate(prompt, model: 'gemini-1.5-flash');
    print('RAW RESPONSE: $raw');

    // JSONだけ返る想定, 念のためガード
    List<dynamic> decoded;
    try {
      decoded = json.decode(raw) as List<dynamic>;
    } catch (_) {
      final m = RegExp(r'\[[\s\S]*\]').firstMatch(raw);
      decoded =
          m != null ? (json.decode(m.group(0)!) as List<dynamic>) : <dynamic>[];
    }

    final list = decoded.cast<Map<String, dynamic>>();
    return list.map(TaskDraft.fromMap).toList();
  }
}
