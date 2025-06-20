import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/models/todo.dart';

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>(
  (ref) => TodoListNotifier(),
);

class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([Todo('ドライブ'), Todo('勉強'), Todo('ゲームする')]);

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
