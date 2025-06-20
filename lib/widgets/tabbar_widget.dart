import 'package:next_todo/constants/colors.dart';
import 'package:flutter/material.dart';

class TabbarWidget extends StatelessWidget {
  const TabbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: AppColors.emeraldgreen,
      labelColor: AppColors.emeraldgreen,
      unselectedLabelColor: Colors.white,
      isScrollable: true,
      tabs: [Tab(text: 'todo'), Tab(text: '使い方'), Tab(icon: Icon(Icons.add))],
    );
  }
}
