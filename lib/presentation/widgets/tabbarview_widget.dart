import 'package:flutter/material.dart';
import 'package:next_todo/presentation/widgets/todolist_UI_widget.dart';

//生成されたタブの数と同数のtabbarviewを生成するwidget
//tabbarviewとはタブごとにTodoリストを表示するもの
class TabbarviewWidget extends StatelessWidget {
  const TabbarviewWidget({super.key, required this.tabs});
  final List<String> tabs;
  @override
  Widget build(BuildContext context) {
    //それぞれのタブごとにTodoリストを生成・表示する

    return TabBarView(
      children: [
        for (final tab in tabs)
          if (tab.isEmpty)
            const Center(
              child: Text('タブがありません', style: TextStyle(color: Colors.white)),
            )
          else
            TodoListTab(tabTitle: tab),
      ],
    );
  }
}
