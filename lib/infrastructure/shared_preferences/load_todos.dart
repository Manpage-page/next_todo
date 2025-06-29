import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:next_todo/domain/models/todo.dart';

Future<List<Todo>> loadTodos() async {
  final prefs = await SharedPreferences.getInstance();

  final jsonList = prefs.getStringList('todoList') ?? [];

  return jsonList.map((jsonStr) => Todo.fromJson(jsonDecode(jsonStr))).toList();
}
