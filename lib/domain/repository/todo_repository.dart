import 'package:next_todo/domain/models/todo.dart';

//セーブロードのインターフェース(ifrastructure層で実装)
abstract class TodoRepository {
  //--------------todolist-----------------

  //セーブ機能
  Future<void> saveTodos(String listId, List<Todo> todos);
  //保存機能(todoのリストを返す)
  Future<List<Todo>> loadTodos(String listId);

  //---------------tab---------------------

  //ロード機能(ストリングのリストを返す)
  Future<List<String>> loadTabs();
  //セーブ機能
  Future<void> saveTabs(List<String> tabs);

  //------- 選択されたtabのindex -----------

  //ロード機能
  Future<int?> loadSelectedIndex(); // ← new
  //セーブ機能
  Future<void> saveSelectedIndex(int index); // ← new
}
