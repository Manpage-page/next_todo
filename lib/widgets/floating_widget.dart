import 'package:flutter/material.dart';
import 'package:next_todo/constants/colors.dart';

class FloatingWidget extends StatelessWidget {
  const FloatingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //削除ボタン
          FloatingActionButton(
            heroTag: 'delete',
            onPressed: () {
              print('削除ボタン');
            },
            backgroundColor: AppColors.grey,
            shape: const CircleBorder(),
            child: Icon(Icons.delete_outline, color: AppColors.emeraldgreen),
          ),
          //ここまで削除ボタン
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
          //ここまでundoボタン
          SizedBox(width: 16),
          //追加ボタン
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () {
              print('追加ボタン');
            },
            backgroundColor: AppColors.emeraldgreen,
            shape: const CircleBorder(),
            child: Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
