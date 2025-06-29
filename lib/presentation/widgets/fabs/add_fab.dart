import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/state/providers/todolist_notifier.dart';
import 'package:next_todo/application/state/providers/selected_index_notifier.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:next_todo/infrastructure/shared_preferences/save_todos.dart';

class AddFAB extends ConsumerWidget {
  const AddFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(selectedIndexNotifierProvider);
    final tabList = ref.watch(tabListNotifierProvider);
    final currentTabName = tabList[currentIndex];

    return FloatingActionButton(
      heroTag: 'add',
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
                  onPressed: () async {
                    if (inputText.trim().isNotEmpty) {
                      final notifier = ref.read(
                        todoListNotifierProvider(currentTabName).notifier,
                      );
                      notifier.addTodo(inputText.trim());
                      final todos = ref.read(
                        todoListNotifierProvider(currentTabName),
                      );

                      await saveTodos(todos); //セーブする
                    }
                    Navigator.pop(context);
                  },
                  child: Text('追加'),
                ),
              ],
            );
          },
        );
      },
      backgroundColor: AppColors.emeraldgreen,
      shape: const CircleBorder(),
      child: Icon(Icons.add, color: Colors.black),
    );
  }
}
