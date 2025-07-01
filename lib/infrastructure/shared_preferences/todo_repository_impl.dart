import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:next_todo/domain/models/todo.dart';
import 'package:next_todo/domain/repository/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  //-------tabsについて----------
  /*
データ構造

_tabsKey = 'tabs': ['todo', '使い方', '+'

'Todolist_todo':[]
'TodoList_使い方':[]
'Todolist_+':[]
}

*/
  static const _tabsKey = 'tabs';

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  @override
  Future<List<String>> loadTabs() async {
    final p = await _prefs;
    final saved = p.getStringList(_tabsKey);

    if (saved == null || saved.isEmpty) {
      final defaultTabs = ['Todo', '+'];
      await p.setStringList(_tabsKey, defaultTabs); // ← 初期値を保存！
      return defaultTabs;
    }

    return saved; //もし_tabskeyがnullなら、+ を返す
  }

  @override
  Future<void> saveTabs(List<String> tabs) async {
    final p = await _prefs;
    await p.setStringList(_tabsKey, tabs); //引数としてtabsを持ってきてそれを
  }

  //----todoについて-------

  //リストのキーを取得
  String _makeKey(String tabId) => 'TodoList_$tabId';

  @override
  //セーブ機能
  Future<void> saveTodos(String tabId, List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList(_makeKey(tabId), jsonList);
  }

  @override
  //ロード機能
  Future<List<Todo>> loadTodos(String tabId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_makeKey(tabId)) ?? [];
    return jsonList
        .map((jsonStr) => Todo.fromJson(jsonDecode(jsonStr)))
        .toList();
  }

  //selectedIndexについて
  static const _selectedIndexKey = 'selectedTabIndex';

  @override
  Future<int?> loadSelectedIndex() async {
    final p = await _prefs;
    return p.getInt(_selectedIndexKey);
  }

  @override
  Future<void> saveSelectedIndex(int index) async {
    final p = await _prefs;
    await p.setInt(_selectedIndexKey, index);
  }
}
