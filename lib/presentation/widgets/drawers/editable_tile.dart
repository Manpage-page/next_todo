import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:next_todo/application/state/providers/tab_list_notifier.dart';
import 'package:next_todo/presentation/constants/colors.dart';

class EditableTile extends ConsumerWidget {
  const EditableTile({
    required Key key,
    required this.index,
    required this.title,
  }) : super(key: key);

  final int index;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(tabListNotifierProvider.notifier);

    return Material(
      color: const Color(0xFF1B1B1B),
      child: ReorderableDelayedDragStartListener(
        // “三本線”だけドラッグ可能
        index: index,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
            onPressed: () => notifier.removeTab(title),
          ),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.drag_handle, color: Colors.white54),
          onTap: () async {
            final controller = TextEditingController(text: title);
            final newName = await showDialog<String>(
              context: context,
              builder:
                  (_) => AlertDialog(
                    backgroundColor: Colors.black,
                    title: const Text(
                      '名前を変更',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: TextField(
                      controller: controller,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: AppColors.emeraldgreen,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed:
                            () =>
                                Navigator.pop(context, controller.text.trim()),
                        child: const Text('保存'),
                      ),
                    ],
                  ),
            );
            if (newName != null && newName.isNotEmpty && newName != title) {
              notifier.renameTab(oldName: title, newName: newName);
            }
          },
        ),
      ),
    );
  }
}
