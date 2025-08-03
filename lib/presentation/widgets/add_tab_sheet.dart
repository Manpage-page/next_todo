//現在このコードは使っていない

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/state/providers/selected_index_notifier.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';

import 'package:next_todo/presentation/constants/colors.dart';

class AddTabSheet extends ConsumerStatefulWidget {
  const AddTabSheet({super.key});

  @override
  ConsumerState<AddTabSheet> createState() => _AddSimpleTodoSheetState();
}

class _AddSimpleTodoSheetState extends ConsumerState<AddTabSheet> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 入力欄だけ
          TextField(
            controller: _controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              hintText: 'タスクを入力',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 24),

          // 閉じる + 追加 ボタン
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('閉じる'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emeraldgreen,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () async {
                    final name = _controller.text.trim();
                    if (name.isEmpty) return;
                    //タブを追加

                    await ref
                        .read(tabListNotifierProvider.notifier)
                        .addTab(name);

                    final tabs = ref.read(tabListNotifierProvider).value ?? [];
                    final idx = tabs.indexOf(name);
                    if (idx != -1) {
                      ref
                          .read(selectedIndexNotifierProvider.notifier)
                          .update(idx);
                    }
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('追加'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
