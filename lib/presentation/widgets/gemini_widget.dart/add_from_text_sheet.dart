import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/state/gemini_providers/gemini_providers.dart';
import 'package:next_todo/application/services/task_extract_service.dart';
import 'package:next_todo/application/state/providers/todolist_notifier.dart';
import 'package:next_todo/presentation/constants/colors.dart';

//修正箇所あり（★）
//抽出追加を行うクラス
class AddFromTextSheet extends ConsumerStatefulWidget {
  final String currentTab; // 追加先タブの変数
  const AddFromTextSheet({super.key, required this.currentTab});

  @override
  ConsumerState<AddFromTextSheet> createState() => _AddFromTextSheetState();
}

class _AddFromTextSheetState extends ConsumerState<AddFromTextSheet> {
  final controller = TextEditingController();
  List<TaskDraft> drafts = []; //タスク候補を保持
  final selected = <int>{}; //選択したタスクのインデックスを保持
  bool loading = false; //抽出処理進行中か否か
  String? error;
  String? info;

  //文字列の日付をDateTimeオブジェクトに変換
  DateTime? _parseDue(String? s) =>
      (s == null || s.isEmpty) ? null : DateTime.tryParse(s);

  //優先度に応じて色を変える（この部分は修正予定）★
  Color _priorityToColor(String? p) {
    switch (p) {
      case 'high':
        return AppColors.emeraldgreen;
      case 'low':
        return Colors.white70;
      case 'normal':
      default:
        return Colors.white; // デフォルト色
    }
  }

  //タスク抽出
  Future<void> _extract() async {
    //ローディング開始
    setState(() {
      loading = true;
      error = null;
      info = null;
      drafts = [];
      selected.clear();
    });
    try {
      //taskExtractServiceProviderでテキストをタスクに分割
      final svc = ref.read(taskExtractServiceProvider);
      final res = await svc.splitTasks(controller.text.trim());
      if (!mounted) return;
      //抽出結果をdraftsに代入
      setState(() {
        drafts = res;
        info = res.isEmpty
            ? 'タスク候補が見つかりませんでした。入力内容を見直して再度お試しください。'
            : null;
      });
    } on MissingGeminiApiKeyException {
      if (!mounted) return;
      setState(() {
        info = null;
        error =
            'Gemini APIキーが設定されていません。flutter run --dart-define=GEMINI_API_KEY=YOUR_KEY で指定してください。';
      });
    } on TaskExtractionException catch (e) {
      if (!mounted) return;
      setState(() {
        info = null;
        error = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        info = null;
        error = '抽出に失敗しました: $e';
      });
    } finally {
      if (!mounted) return;
      //ローディング終了
      setState(() {
        loading = false;
      });
    }
  }

  //選択されたタスクをtodoリストに追加する
  Future<void> _addSelected() async {
    if (selected.isEmpty) {
      setState(() {
        error = null;
        info = '追加するタスクを少なくとも1件選択してください。';
      });
      return;
    }
    //currentTabのnotifierを取得
    final notifier = ref.read(
      todoListNotifierProvider(widget.currentTab).notifier,
    );

    //選択されたタスクを追加
    for (final i in selected) {
      final d = drafts[i];
      notifier.addTodo(
        d.title,
        color: _priorityToColor(d.priority),
        dueDate: _parseDue(d.due),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // 安全な領域内に描画
      child: Padding(
        padding: const EdgeInsets.all(16), //全体の余白
        child: Column(
          mainAxisSize: MainAxisSize.min, //必要な高さだけ使う設定
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: controller, //入力を保持・操作
              maxLines: 10, //10行まで入力可
              decoration: const InputDecoration(
                hintText: '長文を貼り付け（例：メール対応）',
                hintStyle: TextStyle(color: AppColors.emeraldgreen),
                filled: true, //背景塗りつぶし
                fillColor: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                //タスク抽出ボタン
                OutlinedButton(
                  onPressed: loading ? null : _extract,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.emeraldgreen,
                    side: const BorderSide(color: AppColors.emeraldgreen),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('タスク抽出'),
                ),

                const SizedBox(width: 12),

                // draftsに抽出結果がある場合は追加ボタンを表示する
                if (drafts.isNotEmpty)
                  OutlinedButton(
                    onPressed: selected.isEmpty ? null : _addSelected,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.emeraldgreen,
                      side: const BorderSide(color: AppColors.emeraldgreen),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text('選択した${selected.length}件を追加'),
                  ),
              ],
            ),

            //ローディング中の表示
            if (loading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(), //読み込み中のスピナー
              ),
            //エラー表示
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            if (info != null && error == null)
              Text(info!, style: const TextStyle(color: Colors.white70)),
            //抽出結果リスト
            if (drafts.isNotEmpty) ...[
              const Divider(),

              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: drafts.length, //抽出タスク数
                  itemBuilder: (_, i) {
                    final d = drafts[i];
                    final checked = selected.contains(i); // 選択状態

                    return CheckboxListTile(
                      activeColor: Colors.transparent,
                      checkColor: AppColors.emeraldgreen,
                      value: checked,
                      onChanged: (v) {
                        setState(() {
                          if (v == true) {
                            selected.add(i); //チェックで追加
                          } else {
                            selected.remove(i); // 外して解除
                          }
                        });
                      },
                      title: Text(
                        d.title,
                        style: TextStyle(color: Colors.white),
                      ), //タスク名

                      subtitle: Text.rich(
                        TextSpan(
                          children: [
                            if (d.note != null)
                              const TextSpan(
                                text: 'メモ: ',
                                style: TextStyle(color: Colors.white38),
                              ),
                            if (d.note != null)
                              const TextSpan(text: ''), // 区切りなしなら消してOK
                            if (d.note != null)
                              TextSpan(
                                text: d.note!,
                                style: const TextStyle(color: Colors.white70),
                              ),

                            if (d.due != null && d.note != null)
                              const TextSpan(
                                text: '  /  ',
                                style: TextStyle(color: Colors.white24),
                              ),
                            if (d.due != null)
                              const TextSpan(
                                text: '期日: ',
                                style: TextStyle(color: Colors.white38),
                              ),
                            if (d.due != null)
                              TextSpan(
                                text: d.due!,
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                ),
                              ),

                            if (d.priority != null &&
                                (d.note != null || d.due != null))
                              const TextSpan(
                                text: '  /  ',
                                style: TextStyle(color: Colors.white24),
                              ),
                            if (d.priority != null)
                              const TextSpan(
                                text: '優先度: ',
                                style: TextStyle(color: Colors.white38),
                              ),
                            if (d.priority != null)
                              TextSpan(
                                text: d.priority!,
                                style: TextStyle(
                                  color: _priorityToColor(d.priority),
                                ), // 既存の関数を活用
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
}

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
