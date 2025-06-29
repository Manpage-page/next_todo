import 'package:flutter/material.dart';
import 'package:next_todo/presentation/constants/colors.dart';

class UndoFAB extends StatelessWidget {
  const UndoFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'undo',
      onPressed: () {
        print('undoボタン');
      },
      backgroundColor: AppColors.grey,
      shape: const CircleBorder(),
      child: Icon(Icons.undo, color: AppColors.emeraldgreen),
    );
  }
}
