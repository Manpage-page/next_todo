import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/providers/todolist_notifier.dart';
import 'package:next_todo/constants/colors.dart';

// Todoリストのタブ画面を定義するWidget（状態監視ができるConsumerWidget）
class TodoListTab extends ConsumerWidget {
  final String tabTitle;
  const TodoListTab({super.key, required this.tabTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // プロバイダから現在のstate(List)を取得（状態監視）
    final todos = ref.watch(
      todoListNotifierProvider(tabTitle),
    ); // todosを定義(仮で'todo'を入れている)

    // 状態を変更できるように、notifier（操作用オブジェクト）も取得
    final notifier = ref.read(todoListNotifierProvider(tabTitle).notifier);

    // Todoリストを表示するリストビュー
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todos.length, // 表示するTodoの数
      onReorder: notifier.reorder, //並べ替え操作のnotifier
      buildDefaultDragHandles: false, //デフォルトのドラッグハンドルは使用しない

      itemBuilder: (context, index) {
        final todo = todos[index]; // 現在のTodoを取得

        return ReorderableDragStartListener(
          key: ValueKey(todo),
          index: index,

          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(16), //リストの角を丸める
            ),

            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              // Todoの状態に応じてアイコンを切り替え
              leading: Icon(
                todo.isDone ? Icons.check_circle : Icons.circle_outlined,
                color: todo.isDone ? AppColors.emeraldgreen : Colors.white,
              ),

              // Todoのタイトルテキスト
              title: Text(
                todo.title,
                style: TextStyle(
                  color: Colors.white,
                  // 完了済みなら打ち消し線（取り消し線）を表示
                  decoration:
                      todo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                  decorationColor: Colors.white,
                  decorationThickness: 2.0,
                ),
              ),
              //ドラッグ用のハンドル
              //trailing: const Icon(Icons.drag_indicator),

              // タップすると完了状態をトグル（切り替え）
              onTap: () => notifier.toggleDone(index),
            ),
          ),
        );
      },
    );
  }
}
