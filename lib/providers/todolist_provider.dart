import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/models/todo.dart';

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>(
  (ref) => TodoListNotifier(),
);

class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([Todo('ドライブ'), Todo('でーと'), Todo('ゲームする')]);

  void toggleDone(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          Todo(state[i].title, isDone: !state[i].isDone)
        else
          state[i],
    ];
  }

  void addTodo(String title) {
    state = [...state, Todo(title)];
  }

  void removeTodo(int index) {
    state = [...state]..removeAt(index);
  }
}
