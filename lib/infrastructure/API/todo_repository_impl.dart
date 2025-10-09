import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:next_todo/domain/models/todo.dart';
import 'package:next_todo/domain/repository/todo_repository.dart';

/*
データ構造
_tabsKey = 'tabs': ['todo', '使い方', '+'
'Todolist_todo':[]
'TodoList_使い方':[]
'Todolist_+':[]
}
*/

class TodoRepositoryImpl implements TodoRepository {
  //-------tabsについて----------
  //キー名を tabs にする
  static const _tabsKey = 'tabs';

  //SharedPreferencesを非同期で取得
  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  @override
  Future<List<String>> loadTabs() async {
    // SharedPreferencesに保存されているタブの一覧を読み込む

    final p = await _prefs; //取得したインスタンスをpに代入
    final saved = p.getStringList(_tabsKey); //tabsに入っているリストを取得しsavedに代入

    //もしリストにデータが存在しないor中身がない場合
    if (saved == null || saved.isEmpty) {
      //デフォルトのタブを保存して返す
      final defaultTabs = ['Todo'];
      await p.setStringList(
        _tabsKey,
        defaultTabs,
      ); //tabsKey：保存するためのキー、defaulttabs：保存するデータ
      return defaultTabs;
      // 'tabs':['Todo']となる
    }

    return saved; //すでに保存されているものを返す
  }

  @override
  Future<void> saveTabs(List<String> tabs) async {
    //タブのリストデータを保存する
    final p = await _prefs;
    await p.setStringList(_tabsKey, tabs);
  }

  //----todoについて-------

  //リストのキーを取得
  String _makeKey(String tabId) => 'TodoList_$tabId';
  /*
  tabIdをもとにそのタブ用のキーを作る。
  _makeKey('todo') → 'TodoList_todo'

  */

  @override
  //セーブ機能
  Future<void> saveTodos(String tabId, List<Todo> todos) async {
    //todoクラスのリストをjsonリストに変換して保存
    final prefs = await SharedPreferences.getInstance();
    final jsonList = todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList(_makeKey(tabId), jsonList);
  }

  @override
  //ロード機能
  Future<List<Todo>> loadTodos(String tabId) async {
    //jsonリストをtodoクラスのリストに変換
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_makeKey(tabId)) ?? [];
    return jsonList
        .map((jsonStr) => Todo.fromJson(jsonDecode(jsonStr)))
        .toList();
  }

  //----selectedIndexについて-----------
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
