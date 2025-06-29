import 'package:next_todo/domain/models/todo.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'todolist_notifier.g.dart';

@riverpod
class TodoListNotifier extends _$TodoListNotifier {
  @override
  List<Todo> build(String tabTitle) {
    ref.keepAlive(); //画面遷移後でもプロバイダを破棄しない
    return [Todo(title: '新しく追加')];
  }

  //チェックを入れる
  void toggleDone(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        //選択されたリストのインデックスのisDoneを反転
        if (i == index)
          state[i].copyWith(isDone: !state[i].isDone)
        else
          state[i],
    ];
  }

  //リストを追加
  void addTodo(String title) {
    state = [...state, Todo(title: title)];
  }

  //リストを削除
  void removeTodo(int index) {
    state = [...state]..removeAt(index);
  }

  //チェック入りリストをすべて削除
  void removeCompleted() {
    state = state.where((todo) => !todo.isDone).toList();
  }

  //リスト並べ替えのメソッド
  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1; //入れ替え先のインデックスは1前にずれる
    final updated = [...state];
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    state = updated;
  }
}
