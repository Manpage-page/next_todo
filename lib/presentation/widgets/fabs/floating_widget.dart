import 'package:flutter/material.dart';
import 'add_fab.dart';
import 'delete_fab.dart';
import 'undo_fab.dart';

class FloatingWidget extends StatelessWidget {
  const FloatingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          DeleteFAB(),
          SizedBox(width: 20),
          UndoFAB(),
          SizedBox(width: 16),
          AddFAB(),
        ],
      ),
    );
  }
}
