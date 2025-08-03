import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/state/providers/todolist_notifier.dart';
import 'package:next_todo/application/state/providers/selected_index_notifier.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';
import 'package:next_todo/presentation/constants/colors.dart';

class DeleteFAB extends ConsumerWidget {
  const DeleteFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(selectedIndexNotifierProvider);

    final asyncTabs = ref.watch(tabListNotifierProvider);

    if (asyncTabs.isLoading || asyncTabs.hasError) {
      return const SizedBox.shrink();
    }

    final tabs = asyncTabs.value ?? ['+'];
    final currentTabName = tabs[currentIndex];

    return FloatingActionButton(
      heroTag: 'delete',
      onPressed: () {
        ref
            .read(todoListNotifierProvider(currentTabName).notifier)
            .removeCompleted();
      },
      backgroundColor: AppColors.grey,
      shape: const CircleBorder(),
      child: Icon(Icons.delete_outline, color: AppColors.emeraldgreen),
    );
  }
}
