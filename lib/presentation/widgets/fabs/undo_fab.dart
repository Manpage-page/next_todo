import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:next_todo/application/state/providers/todo_repository_provider.dart';

class UndoFAB extends ConsumerWidget {
  const UndoFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      heroTag: 'undo',
      //いったんundoをデバッグボタンにする
      onPressed: () async {
        debugPrint('🌀 Debug dump start');

        // 共通で使う Repository を読んじゃう
        final repo = ref.read(todoRepositoryProvider);

        // 1. すべてのタブをロード
        final tabs = await repo.loadTabs();
        debugPrint('Tabs: $tabs');

        // 2. 各タブの Todo をロードして出力
        for (final tab in tabs) {
          final todos = await repo.loadTodos(tab);
          debugPrint('[$tab] ${todos.length}件');
          for (final t in todos) {
            debugPrint('  • ${t.title}  (done:${t.isDone})  id:${t.id}');
          }
        }

        // 3. 選択中インデックスもチラ見せ
        final selected = await repo.loadSelectedIndex();
        debugPrint('selectedTabIndex: $selected');

        debugPrint('🌀 Debug dump end\n');
      },

      backgroundColor: AppColors.grey,
      shape: const CircleBorder(),
      child: Icon(Icons.undo, color: AppColors.emeraldgreen),
    );
  }
}
