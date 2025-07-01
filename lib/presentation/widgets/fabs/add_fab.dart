import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/state/providers/todolist_notifier.dart';
import 'package:next_todo/application/state/providers/selected_index_notifier.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';
import 'package:next_todo/domain/repository/todo_repository.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:next_todo/infrastructure/shared_preferences/todo_repository_impl.dart';

class AddFAB extends ConsumerWidget {
  const AddFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 選択中インデックス
    final currentIndex = ref.watch(selectedIndexNotifierProvider);
    // 2. タブ一覧（AsyncValue）を取得
    final asyncTabs = ref.watch(tabListNotifierProvider);
    // 3. ローディング or エラー時のフォールバック
    if (asyncTabs.isLoading) {
      return const SizedBox.shrink(); // 読み込み中はFAB出さない（お好みで）
    }
    if (asyncTabs.hasError) {
      return const SizedBox.shrink(); // エラー時も非表示（お好みで）
    }

    final tabs = asyncTabs.value ?? ['+'];
    final currentTabName = tabs[currentIndex];

    final todoRepositoryImplProvider = Provider<TodoRepository>(
      (ref) => TodoRepositoryImpl(),
    );
    final repository = ref.read(todoRepositoryImplProvider);
    //final todos = await repository.loadTodos();

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

                      await repository.saveTodos(currentTabName, todos); //セーブする
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
