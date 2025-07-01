import 'package:flutter/material.dart';
import 'package:next_todo/domain/models/todo.dart';
import 'package:next_todo/domain/repository/todo_repository.dart';

/*
// ChangeNotifierを継承することで、UIに変更を通知する仕組みを利用できる
class TodoListViewModel extends ChangeNotifier {
  // コンストラクタで、リポジトリの実装を受け取る（依存性の注入）
  TodoListViewModel({required TodoRepository repository})
    : _repository = repository;

  final TodoRepository _repository;

  // --- アプリケーションの状態 ---
  // これらが実際にメモリ上で保持される「データ」
  bool _isLoading = true; // ローディング中かどうかのフラグ
  List<String> _tabs = []; // 現在のタブのリスト
  String _selectedTab = ''; // 選択されているタブ
  List<Todo> _currentTodos = []; // 表示中のToDoリスト

  // --- UIが状態を読み取るためのゲッター ---
  // UIからはこれらのゲッターを通じて状態にアクセスする
  bool get isLoading => _isLoading;
  List<String> get tabs => _tabs;
  String get selectedTab => _selectedTab;
  List<Todo> get currentTodos => _currentTodos;

  // --- アプリケーションのロジック ---

  // 1. アプリ起動時にデータを初期化するメソッド
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners(); // ローディング開始をUIに通知

    // リポジトリを使ってタブのリストを読み込む
    _tabs = await _repository.loadTabs();

    if (_tabs.isNotEmpty) {
      // 最初のタブを選択状態にする
      _selectedTab = _tabs.first;
      // 選択されたタブに対応するToDoリストを読み込む
      _currentTodos = await _repository.loadTodos(_selectedTab);
    }

    _isLoading = false;
    notifyListeners(); // ローディング完了とデータ更新をUIに通知
  }

  // 2. ToDoを新しく追加するメソッド
  Future<void> addTodo(String title) async {
    // 新しいTodoオブジェクトを作成
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // IDは一意なものを生成
      title: title,
      isDone: false,
    );

    // メモリ上のリストに追加
    _currentTodos.add(newTodo);

    // リポジトリを使って、変更後のリストを永続化（保存）する
    await _repository.saveTodos(_selectedTab, _currentTodos);

    // UIに変更を通知
    notifyListeners();
  }

  // 3. タブを切り替えるメソッド
  Future<void> selectTab(String tabId) async {
    _selectedTab = tabId;
    _isLoading = true;
    notifyListeners();

    // 新しく選択されたタブのToDoリストをリポジトリから読み込む
    _currentTodos = await _repository.loadTodos(_selectedTab);

    _isLoading = false;
    notifyListeners();
  }

  // 他にも、タブの追加・削除、ToDoの完了・削除などのメソッドをここに追加していく

  // 1. タブを追加する
  Future<void> addTab(String tabName) async {
    if (_tabs.contains(tabName) || tabName == '+') return;

    _tabs.insert(_tabs.length - 1, tabName); // '+'の前に追加
    await _repository.saveTabs(_tabs);

    // 空のリストを保存しておく（念のため）
    await _repository.saveTodos(tabName, []);

    notifyListeners();
  }

  // 2. タブを削除する
  Future<void> removeTab(String tabName) async {
    if (tabName == '+') return; // '+'は削除不可

    _tabs.remove(tabName);
    await _repository.saveTabs(_tabs);

    // Todo自体は消してもいいし残してもいいけど、今回は削除する
    await _repository.saveTodos(tabName, []);

    // 選択中のタブを削除した場合は先頭に切り替える
    if (_selectedTab == tabName) {
      _selectedTab = _tabs.first;
      _currentTodos = await _repository.loadTodos(_selectedTab);
    }

    notifyListeners();
  }

  // 3. ToDoの完了チェック切り替え
  Future<void> toggleTodoDone(int index) async {
    final todo = _currentTodos[index];
    _currentTodos[index] = todo.copyWith(isDone: !todo.isDone);
    await _repository.saveTodos(_selectedTab, _currentTodos);
    notifyListeners();
  }

  // 4. ToDoの削除
  Future<void> removeTodo(int index) async {
    _currentTodos.removeAt(index);
    await _repository.saveTodos(_selectedTab, _currentTodos);
    notifyListeners();
  }
}
*/
