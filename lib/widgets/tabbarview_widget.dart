import 'package:flutter/material.dart';
import 'package:next_todo/widgets/todolist_tab_widget.dart';

class TabbarviewWidget extends StatelessWidget {
  const TabbarviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Center(child: TodoListTab()),
        Center(child: Text('タブ2の中身', style: TextStyle(color: Colors.white))),
        Center(child: Text('タブ3の中身', style: TextStyle(color: Colors.white))),
      ],
    );
  }
}
