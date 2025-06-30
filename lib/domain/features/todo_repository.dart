import 'package:next_todo/domain/models/todo.dart';

//セーブロードのインターフェース(ifrastructure層で実装)
abstract class TodoRepository {
  //セーブ機能
  Future<void> saveTodos(List<Todo> todos);
  //保存機能
  Future<List<Todo>> loadTodos();
}
