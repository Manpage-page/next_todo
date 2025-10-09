import 'package:next_todo/domain/models/todo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:next_todo/domain/repository/todo_repository.dart';
import 'package:next_todo/application/state/providers/todo_repository_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' show Color;
part 'todolist_notifier.g.dart';

@riverpod
class TodoListNotifier extends _$TodoListNotifier {
  late final TodoRepository _repo;
  late String _currentTab;

  @override
  List<Todo> build(String tabTitle) {
    _repo = ref.read(todoRepositoryProvider);
    _currentTab = tabTitle;
    _load(tabTitle);
    return [];
  }

  void _load(String tabTitle) async {
    final loaded = await _repo.loadTodos(tabTitle);
    state = loaded;
  }

  Future<void> setDueDate(String id, DateTime? due) async {
    var hasUpdated = false;
    final updated = [
      for (final t in state)
        if (t.id == id)
          () {
            hasUpdated = true;
            return t.copyWith(dueDate: due);
          }()
        else
          t,
    ];
    if (!hasUpdated) {
      return;
    }
    state = updated;
    await _repo.saveTodos(_currentTab, state);
  }

  void toggleDoneById(String id) async {
    final i = state.indexWhere((t) => t.id == id);
    if (i == -1) return;
    final updated = state[i].copyWith(isDone: !state[i].isDone);
    state = [...state]..[i] = updated; // 先にUI反映
    await _repo.saveTodos(_currentTab, state);
  }

  void addTodo(String title, {required Color color, DateTime? dueDate}) async {
    final uuid = Uuid(); // ← インスタンス生成
    final newTodo = Todo(
      id: uuid.v4(), // ← UUIDをIDに
      title: title,
      createdAt: DateTime.now(),
      color: color.value,
      dueDate: dueDate,
    );
    state = [...state, newTodo];
    await _repo.saveTodos(_currentTab, state);
  }

  void removeTodo(int index) async {
    state = [...state]..removeAt(index);
    await _repo.saveTodos(_currentTab, state);
  }

  void removeCompleted() async {
    state = state.where((t) => !t.isDone).toList();
    await _repo.saveTodos(_currentTab, state); // 自動保存
  }

  void toggleDone(int index) async {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(isDone: !state[i].isDone)
        else
          state[i],
    ];
    await _repo.saveTodos(_currentTab, state);
  }

  void reorder(int oldIndex, int newIndex) async {
    // ReorderableListView のお決まり：後ろに動かす時は 1 つ減らす
    if (newIndex > oldIndex) newIndex -= 1;

    final updated = [...state];
    final moved = updated.removeAt(oldIndex);
    updated.insert(newIndex, moved);

    state = updated;
    await _repo.saveTodos(_currentTab, state);
  }
}
