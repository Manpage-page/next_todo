import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:next_todo/application/state/providers/todo_repository_provider.dart';

class UndoFAB extends ConsumerWidget {
  const UndoFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      heroTag: 'undo',
      //いったんundoをデバッグボタンにする
      onPressed: () async {
        final repo = ref.read(todoRepositoryProvider);

        final tabs = await repo.loadTabs();
        debugPrint('Tabs: $tabs');

        for (final tab in tabs) {
          final todos = await repo.loadTodos(tab);
          debugPrint('[$tab] ${todos.length}件');
          for (final t in todos) {
            debugPrint('  • ${t.title}  (done:${t.isDone})  id:${t.id}');
          }
        }

        final selected = await repo.loadSelectedIndex();
        debugPrint('selectedTabIndex: $selected');

        debugPrint('Debug dump end\n');
      },

      backgroundColor: AppColors.grey,
      shape: const CircleBorder(),
      child: Icon(Icons.undo, color: AppColors.emeraldgreen),
    );
  }
}
