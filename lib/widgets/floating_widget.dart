import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/constants/colors.dart';
import 'package:next_todo/providers/selected_index_notifier.dart';
import 'package:next_todo/providers/tab_list_notifier.dart';
import 'package:next_todo/providers/todolist_notifier.dart';

class FloatingWidget extends ConsumerWidget {
  const FloatingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //タブの名前を取得するためにインデックスとリストを取得している
    final currentIndex = ref.watch(
      selectedIndexNotifierProvider,
    ); //現在選択されているタブのインデックス
    final tabList = ref.watch(tabListNotifierProvider); //タブのリスト
    final currentTabName = tabList[currentIndex]; //現在選択されているタブの値

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //削除ボタン
          FloatingActionButton(
            heroTag: 'delete', //FABの識別用
            //完了済みのリストをすべて削除
            onPressed: () {
              ref
                  .read(todoListNotifierProvider(currentTabName).notifier)
                  .removeCompleted();
            },

            backgroundColor: AppColors.grey,
            shape: const CircleBorder(),
            child: Icon(Icons.delete_outline, color: AppColors.emeraldgreen),
          ),
          SizedBox(width: 20),
          //undoボタン
          FloatingActionButton(
            heroTag: 'undo',

            //未実装
            onPressed: () {
              print('undoボタン');
            },

            backgroundColor: AppColors.grey,
            shape: const CircleBorder(),
            child: Icon(Icons.undo, color: AppColors.emeraldgreen),
          ),
          SizedBox(width: 16),
          //追加ボタン
          FloatingActionButton(
            heroTag: 'add',

            //リストを追加する
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  String inputText = '';
                  return AlertDialog(
                    title: Text('やることを追加'),
                    content: TextField(
                      autofocus: true,
                      onChanged: (value) => inputText = value,
                      decoration: InputDecoration(hintText: '例: 散歩に行く'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (inputText.trim().isNotEmpty) {
                            ref
                                .read(
                                  todoListNotifierProvider(
                                    currentTabName,
                                  ).notifier,
                                )
                                .addTodo(inputText.trim());
                          }
                          Navigator.pop(context);
                        },
                        child: Text('追加'),
                      ),
                    ],
                  );
                },
              );
              print('追加ボタン');
            },

            backgroundColor: AppColors.emeraldgreen,
            shape: const CircleBorder(),
            child: Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
