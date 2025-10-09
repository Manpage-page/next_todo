import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:next_todo/domain/repository/todo_repository.dart';
import 'package:next_todo/application/state/providers/todolist_notifier.dart';
import 'package:next_todo/presentation/utils/date_time_picker.dart';
import 'package:intl/intl.dart';

//タスクを追加するためのシートのUI
class AddTodoSheet extends ConsumerStatefulWidget {
  const AddTodoSheet({
    required this.tabName,
    required this.repository,
    super.key,
  });

  final String tabName; //追加先のタブ名
  final TodoRepository repository; // 永続化のためにのリポジトリ

  @override
  ConsumerState<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends ConsumerState<AddTodoSheet> {
  final _controller = TextEditingController();
  Color _selected = Colors.white; // 入力時の色選択

  DateTime? _dueDate; // 期限

  @override
  void dispose() {
    // TextEditingControllerを破棄してメモリにたまるのを防ぐ
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final notifier = ref.read(
      todoListNotifierProvider(widget.tabName).notifier,
    );
    notifier.addTodo(text, color: _selected, dueDate: _dueDate);

    final todos = ref.read(todoListNotifierProvider(widget.tabName));
    await widget.repository.saveTodos(widget.tabName, todos);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //現在のタブのnotifierを取得
    final notifier = ref.read(
      todoListNotifierProvider(widget.tabName).notifier,
    );

    //期限ラベル：期限を追加してない場合は'期限・通知'が表示される
    final dueLabel =
        _dueDate != null ? DateFormat('M/d HH:mm').format(_dueDate!) : '期限・通知';

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        12 + MediaQuery.of(context).viewInsets.bottom,
      ),
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

            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),

          // 色選択
          Wrap(
            spacing: 8,
            children:
                AppColors.palette.map((c) {
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
                label: dueLabel,
                onTap: () async {
                  final picked = await pickDateTime(context, initial: _dueDate);
                  if (picked != null) {
                    setState(() => _dueDate = picked);
                  }
                },
                onLongPress: () => setState(() => _dueDate = null),
              ),
              _DateChip(
                label: '今日',
                onTap: () {
                  setState(() => _dueDate = endOfDay(DateTime.now()));
                },
              ),
              _DateChip(
                label: '明日',
                onTap: () {
                  setState(
                    () =>
                        _dueDate = endOfDay(
                          DateTime.now().add(const Duration(days: 1)),
                        ),
                  );
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

                    notifier.addTodo(text, color: _selected, dueDate: _dueDate);

                    final todos = ref.read(
                      todoListNotifierProvider(widget.tabName),
                    );
                    await widget.repository.saveTodos(widget.tabName, todos);
                    if (!mounted) return;
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
  const _DateChip({
    required this.label,
    required this.onTap,
    this.onLongPress,
    //super.key,
  });

  final String label;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      onLongPress: onLongPress,
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
