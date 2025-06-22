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
    final todos = ref.watch(todoListNotifierProvider); // todosを定義

    // 状態を変更できるように、notifier（操作用オブジェクト）も取得
    final notifier = ref.read(todoListNotifierProvider.notifier);

    // Todoリストを表示するリストビュー
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todos.length, // 表示するTodoの数
      itemBuilder: (context, index) {
        final todo = todos[index]; // 現在のTodoを取得

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6), // 上下の余白
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.circular(16), // 角を丸く
          ),
          child: ListTile(
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
              ),
            ),
            // タップすると完了状態をトグル（切り替え）
            onTap: () => notifier.toggleDone(index),
          ),
        );
      },
    );
  }
}
