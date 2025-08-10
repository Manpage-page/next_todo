import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/state/providers/todolist_notifier.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:next_todo/presentation/widgets/ischeck_icon_widget.dart';
import 'package:intl/intl.dart';

class TodoListTab extends ConsumerStatefulWidget {
  final String tabTitle;
  const TodoListTab({super.key, required this.tabTitle});

  @override
  ConsumerState<TodoListTab> createState() => _TodoListTabState();
}

class _TodoListTabState extends ConsumerState<TodoListTab> {
  @override
  void initState() {
    super.initState();
    // 次フレームでロード呼び出し（buildより前に完了しなくてOK）
    Future.microtask(() {
      ref.read(todoListNotifierProvider(widget.tabTitle));
    });
  }

  // 期限の表示用ヘルパー（日本語の曜日つき）
  String _formatDue(DateTime d) {
    // 例: 8月5日(火)
    return DateFormat('M月d日(E)', 'ja').format(d);
  }

  @override
  Widget build(BuildContext context) {
    // プロバイダから現在のstate(List)を取得
    final todos = ref.watch(todoListNotifierProvider(widget.tabTitle));
    // 状態を変更できるようにnotifierを持ってきた
    final notifier = ref.read(
      todoListNotifierProvider(widget.tabTitle).notifier,
    );

    final now = DateTime.now();

    // Todoリストを表示するリストビュー
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todos.length,
      onReorder: notifier.reorder,
      buildDefaultDragHandles: false,

      //ドラッグ中のUI設定
      proxyDecorator: (child, index, animation) {
        return Material(
          color: Colors.transparent, // ドラッグ中に光らない設定
          elevation: 0,
          child: child,
        );
      },

      itemBuilder: (context, index) {
        final todo = todos[index];

        final isOverdue =
            (todo.dueDate != null &&
                todo.dueDate!.isBefore(now) &&
                !todo.isDone);
        final dueColor = isOverdue ? Colors.redAccent : Colors.white70;

        return ReorderableDragStartListener(
          key: ValueKey(todo),
          index: index,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(16), // リストの角を丸める
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              // Todoの状態に応じてアイコンを切り替え
              leading: IscheckIconWidget(isDone: todo.isDone),

              // タイトル
              title: Text(
                todo.title,
                style: TextStyle(
                  color: Color(todo.color),
                  decoration:
                      todo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                  decorationColor: Colors.white,
                  decorationThickness: 2.0,
                ),
              ),

              subtitle:
                  (todo.dueDate != null)
                      ? Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.event, size: 16, color: dueColor),
                            const SizedBox(width: 6),
                            Text(
                              _formatDue(todo.dueDate!),
                              style: TextStyle(
                                color: dueColor,
                                fontSize: 12,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      )
                      : null,

              // タップすると完了状態をトグル
              onTap: () => notifier.toggleDone(index),
            ),
          ),
        );
      },
    );
  }
}
