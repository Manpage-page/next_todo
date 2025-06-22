import 'package:flutter/material.dart';
import 'package:next_todo/constants/colors.dart';
import 'package:next_todo/providers/todolist_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloatingWidget extends StatelessWidget {
  const FloatingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //削除ボタン
              FloatingActionButton(
                heroTag: 'delete',
                onPressed: () {
                  ref.read(todoListNotifierProvider.notifier).removeCompleted();
                  print('完了済みのtodoをまとめて削除');
                },
                backgroundColor: AppColors.grey,
                shape: const CircleBorder(),
                child: Icon(
                  Icons.delete_outline,
                  color: AppColors.emeraldgreen,
                ),
              ),
              SizedBox(width: 20),

              //undoボタン
              FloatingActionButton(
                heroTag: 'undo',
                onPressed: () {
                  print('undoボタン');
                },
                backgroundColor: AppColors.grey,
                shape: const CircleBorder(),
                child: Icon(Icons.undo, color: AppColors.emeraldgreen),
              ),
              SizedBox(width: 16),
              //追加ボタン
              FloatingActionButton(
                heroTag: 'add',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      String inputText = '';
                      return AlertDialog(
                        title: Text('やることを追加'),
                        content: TextField(
                          autofocus: true,
                          onChanged: (value) => inputText = value,
                          decoration: InputDecoration(hintText: '例: 散歩に行く'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('キャンセル'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (inputText.trim().isNotEmpty) {
                                ref
                                    .read(todoListNotifierProvider.notifier)
                                    .addTodo(inputText.trim());
                              }
                              Navigator.pop(context);
                            },
                            child: Text('追加'),
                          ),
                        ],
                      );
                    },
                  );
                  print('追加ボタン');
                },
                backgroundColor: AppColors.emeraldgreen,
                shape: const CircleBorder(),
                child: Icon(Icons.add, color: Colors.black),
              ),
            ],
          ),
        );
      },
    );
  }
}
