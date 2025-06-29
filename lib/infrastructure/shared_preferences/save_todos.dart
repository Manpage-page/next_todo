import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:next_todo/domain/models/todo.dart';
// モデルのファイル

Future<void> saveTodos(List<Todo> todos) async {
  final prefs = await SharedPreferences.getInstance();

  // それぞれのTodoをJSON文字列に変換
  final jsonList = todos.map((todo) => jsonEncode(todo.toJson())).toList();

  await prefs.setStringList('todoList', jsonList);
}
