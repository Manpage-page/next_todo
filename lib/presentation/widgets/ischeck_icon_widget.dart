import 'package:flutter/material.dart';
import 'package:next_todo/presentation/constants/colors.dart';

//チェックボタンアイコンの見た目を切り替えるwidget
class IscheckIconWidget extends StatelessWidget {
  const IscheckIconWidget({super.key, required this.isDone});

  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final iconData = isDone ? Icons.check_circle : Icons.circle_outlined;
    final color = isDone ? AppColors.emeraldgreen : Colors.white;

    return Icon(iconData, color: color);
  }
}
