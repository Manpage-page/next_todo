import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';
import 'package:next_todo/presentation/widgets/todolist_tab_widget.dart';

//生成されたタブの数と同数のtabbarviewを生成するwidget
class TabbarviewWidget extends ConsumerWidget {
  const TabbarviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = ref.watch(tabListNotifierProvider);

    //それぞれのタブごとにTodoリストを生成・表示する
    return TabBarView(
      children: [for (final tab in tabs) TodoListTab(tabTitle: tab)],
    );
  }
}
