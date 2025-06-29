import 'package:flutter/material.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UndoFAB extends StatelessWidget {
  const UndoFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'undo',
      //いったんundoをデバッグボタンにする
      onPressed: () async {
        print('undoボタン');
        final prefs = await SharedPreferences.getInstance();
        print('保存されてるキー一覧: ${prefs.getKeys()}');
        print('保存されてるTodoデータ: ${prefs.getStringList('todoList')}');
      },
      backgroundColor: AppColors.grey,
      shape: const CircleBorder(),
      child: Icon(Icons.undo, color: AppColors.emeraldgreen),
    );
  }
}
