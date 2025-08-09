import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/state/providers/selected_index_notifier.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';
import 'package:next_todo/domain/repository/todo_repository.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:next_todo/infrastructure/shared_preferences/todo_repository_impl.dart';
import 'package:next_todo/presentation/widgets/add_todo_sheet.dart';

class AddFAB extends ConsumerWidget {
  const AddFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 選択中インデックス
    final currentIndex = ref.watch(selectedIndexNotifierProvider);
    // タブ一覧（AsyncValue）を取得
    final asyncTabs = ref.watch(tabListNotifierProvider);
    // タブ一覧が読み込み中なら何も表示せず
    if (asyncTabs.isLoading) {
      return const SizedBox.shrink();
    }
    //エラーの際も表示しない
    if (asyncTabs.hasError) {
      return const SizedBox.shrink();
    }

    final tabs = asyncTabs.value ?? ['+'];
    final currentTabName = tabs[currentIndex];

    final todoRepositoryImplProvider = Provider<TodoRepository>(
      (ref) => TodoRepositoryImpl(),
    );
    final repository = ref.read(todoRepositoryImplProvider);

    return FloatingActionButton(
      heroTag: 'add',
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color.fromARGB(255, 28, 28, 28),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder:
              (_) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: AddTodoSheet(
                  tabName: currentTabName,
                  repository: repository,
                ),
              ),
        );
      },
      backgroundColor: AppColors.emeraldgreen,
      shape: const CircleBorder(),
      child: Icon(Icons.add, color: Colors.black),
    );
  }
}
