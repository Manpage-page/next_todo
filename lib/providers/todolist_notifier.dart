import 'package:next_todo/models/todo.dart';
import 'package:next_todo/providers/tab_list_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'todolist_notifier.g.dart';

@riverpod
class TodoListNotifier extends _$TodoListNotifier {
  @override
  List<Todo> build(String tabTitle) {
    ref.keepAlive();
    return [Todo('新しく追加')];
  }

  void toggleDone(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          Todo(state[i].title, isDone: !state[i].isDone)
        else
          state[i],
    ];
  }

  //リストを追加
  void addTodo(String title) {
    state = [...state, Todo(title)];
  }

  //リストを削除
  void removeTodo(int index) {
    state = [...state]..removeAt(index);
  }

  //チェック入りをすべて削除
  void removeCompleted() {
    state = state.where((todo) => !todo.isDone).toList();
  }
}
