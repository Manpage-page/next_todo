import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:next_todo/application/state/providers/tab_list_notifier.dart';
import 'package:next_todo/application/state/providers/todolist_notifier.dart';

class TodoWithTab {
  TodoWithTab({required this.title, required this.tabName});
  final String title;
  final String tabName;
}

/// 全タブからtodoを集める
final allTodosProvider = Provider<List<TodoWithTab>>((ref) {
  final tabsAsync = ref.watch(tabListNotifierProvider);

  return tabsAsync.when(
    // データが取れたとき
    data: (tabs) {
      final List<TodoWithTab> result = [];
      for (final tab in tabs) {
        if (tab == '+') continue; // 「＋」タブは除外
        final todos = ref.watch(todoListNotifierProvider(tab));
        result.addAll(
          todos.map((e) => TodoWithTab(title: e.title, tabName: tab)),
        );
      }
      return result;
    },

    // 読み込み中・エラー時は空リストを返す
    loading: () => [],
    error: (_, __) => [],
  );
});
