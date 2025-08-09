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
      drafts = [];
      selected.clear();
    });
    try {
      //taskExtractServiceProviderでテキストをタスクに分割
      final svc = ref.read(taskExtractServiceProvider);
      final res = await svc.splitTasks(controller.text.trim());
      //抽出結果をdraftsに代入
      setState(() {
        drafts = res;
      });
    } catch (e) {
      setState(() {
        error = '抽出に失敗しました: $e';
      });
    } finally {
      //ローディング終了
      setState(() {
        loading = false;
      });
    }
  }

  //選択されたタスクをtodoリストに追加する
  Future<void> _addSelected() async {
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
              controller: controller, //入力を保持・操作
              maxLines: 10, //10行まで入力可
              decoration: const InputDecoration(
                hintText: '長文を貼り付け（例：メール対応）',
                filled: true, //背景塗りつぶし
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                //タスク抽出ボタン
                ElevatedButton(
                  onPressed: loading ? null : _extract,
                  child: const Text('タスク抽出'),
                ),

                const SizedBox(width: 12),

                // draftsに抽出結果がある場合は追加ボタンを表示する
                if (drafts.isNotEmpty)
                  ElevatedButton(
                    onPressed: _addSelected,
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
                      title: Text(d.title), //タスク名

                      subtitle:
                          [
                                if (d.note != null) d.note!,
                                if (d.due != null) '期限: ${d.due}',
                                if (d.priority != null) '優先度: ${d.priority}',
                              ].whereType<String>().isEmpty
                              ? null
                              : Text(
                                [
                                  if (d.note != null) d.note!,
                                  if (d.due != null) '期日: ${d.due}',
                                  if (d.priority != null) '優先度: ${d.priority}',
                                ].join(' / '),
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
}
