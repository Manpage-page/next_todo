import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:next_todo/domain/models/todo.dart';
import 'package:next_todo/domain/features/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  @override
  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('todoList', jsonList);
  }

  @override
  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('todoList') ?? [];
    return jsonList
        .map((jsonStr) => Todo.fromJson(jsonDecode(jsonStr)))
        .toList();
  }
}
