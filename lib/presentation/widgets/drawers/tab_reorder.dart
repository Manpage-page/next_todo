import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:next_todo/presentation/widgets/drawers/editable_tile.dart';

class TabReorderScreen extends ConsumerWidget {
  const TabReorderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabsAsync = ref.watch(tabListNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'リストの並び替え・編集',
          style: TextStyle(color: AppColors.emeraldgreen),
        ),
        elevation: 0,
      ),
      body: tabsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (e, _) => Center(
              child: Text('エラー: $e', style: const TextStyle(color: Colors.red)),
            ),
        data:
            (tabs) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    '項目をタップするとリスト名を編集できます',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.only(bottom: 32),
                    itemCount: tabs.length,
                    onReorder:
                        (oldIdx, newIdx) => ref
                            .read(tabListNotifierProvider.notifier)
                            .reorder(oldIdx, newIdx),
                    itemBuilder:
                        (context, i) => EditableTile(
                          key: ValueKey(tabs[i]),
                          index: i,
                          title: tabs[i],
                        ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
