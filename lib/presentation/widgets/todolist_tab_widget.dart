import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/state/providers/todolist_notifier.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:next_todo/presentation/widgets/ischeck_icon_widget.dart';

//initstateを使うためConsumerstatefulを使用
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
      // ← ここがキモ
    });
  }

  @override
  Widget build(BuildContext context) {
    //プロバイダから現在のstate(List)を取得
    final todos = ref.watch(todoListNotifierProvider(widget.tabTitle));
    //状態を変更できるようにnotifierを持ってきた
    final notifier = ref.read(
      todoListNotifierProvider(widget.tabTitle).notifier,
    );

    //Todoリストを表示するリストビュー
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todos.length,
      onReorder: notifier.reorder,
      buildDefaultDragHandles: false,

      //ドラッグ中のUI設定
      proxyDecorator: (child, index, animation) {
        return Material(
          color: Colors.transparent, //ドラッグ中に光らない設定
          elevation: 0,
          child: child,
        );
      },

      itemBuilder: (context, index) {
        final todo = todos[index];

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
              leading: IscheckIconWidget(isDone: todo.isDone),

              // Todoのタイトルテキスト
              title: Text(
                todo.title,
                style: TextStyle(
                  color: Color(todo.color),
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
