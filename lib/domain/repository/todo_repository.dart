import 'package:next_todo/domain/models/todo.dart';

//セーブロードのインターフェース(ifrastructure層で実装)
abstract class TodoRepository {
  //セーブ機能
  Future<void> saveTodos(String listId, List<Todo> todos);
  //保存機能
  Future<List<Todo>> loadTodos(String listId);

  Future<List<String>> loadTabs();
  Future<void> saveTabs(List<String> tabs);

  Future<int?> loadSelectedIndex(); // ← new
  Future<void> saveSelectedIndex(int index); // ← new
}
