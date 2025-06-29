import 'package:next_todo/domain/models/todo.dart';

abstract class TodoRepository {
  Future<void> saveTodos(List<Todo> todos);
  Future<List<Todo>> loadTodos();
}
