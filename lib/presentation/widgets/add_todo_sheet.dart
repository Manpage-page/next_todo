import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:next_todo/domain/repository/todo_repository.dart';
import 'package:next_todo/application/state/providers/todolist_notifier.dart';
import 'package:next_todo/presentation/constants/colors.dart';

class AddTodoSheet extends ConsumerStatefulWidget {
  const AddTodoSheet({required this.tabName, required this.repository});

  final String tabName;
  final TodoRepository repository;

  @override
  ConsumerState<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends ConsumerState<AddTodoSheet> {
  final _controller = TextEditingController();
  Color _selected = Colors.white;

  static const _palette = [
    Colors.white,
    Colors.pinkAccent,
    Colors.lightGreen,
    Colors.lightBlue,
    Colors.deepPurpleAccent,
    Colors.yellow,
    Color(0xFF9E8C7A),
    Colors.blueGrey,
  ];

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(
      todoListNotifierProvider(widget.tabName).notifier,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            style: TextStyle(color: _selected, fontSize: 18),
            cursorColor: _selected,
            decoration: const InputDecoration(
              hintText: 'タスクを入力',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 12),

          //色を変更する項目
          Wrap(
            spacing: 8,
            children:
                _palette.map((c) {
                  final selected = c == _selected;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = c),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border:
                            selected
                                ? Border.all(color: Colors.white, width: 2)
                                : null,
                      ),
                    ),
                  );
                }).toList(),
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _DateChip(
                label: '期限・通知',
                onTap: () {
                  /* DatePickerなど */
                },
              ),
              _DateChip(
                label: '今日',
                onTap: () {
                  /* 〃 */
                },
              ),
              _DateChip(
                label: '明日',
                onTap: () {
                  /* 〃 */
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
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
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;
                    notifier.addTodo(
                      text,
                      color: _selected, // Todoモデルに色を持たせておく
                    );
                    final todos = ref.read(
                      todoListNotifierProvider(widget.tabName),
                    );
                    await widget.repository.saveTodos(widget.tabName, todos);
                    Navigator.pop(context);
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

class _DateChip extends StatelessWidget {
  const _DateChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.event, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white54),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
