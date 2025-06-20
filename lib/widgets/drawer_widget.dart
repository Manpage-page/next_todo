import 'package:flutter/material.dart';
import 'package:next_todo/constants/colors.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(backgroundColor: AppColors.emeraldgreen);
  }
}
