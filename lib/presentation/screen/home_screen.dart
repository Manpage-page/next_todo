import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/presentation/widgets/appbar_widget.dart';
import 'package:next_todo/presentation/widgets/drawer_widget.dart';
import 'package:next_todo/presentation/widgets/fabs/floating_widget.dart';
import 'package:next_todo/presentation/widgets/tabbar_widget.dart';
import 'package:next_todo/presentation/widgets/tabbarview_widget.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = ref.watch(tabListNotifierProvider);

    return DefaultTabController(
      length: tabs.length, // タブの数(一応プログラムが動くようにtabsにしているが本来はnormalTabs)
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: const AppbarWidget(),
        drawer: DrawerWidget(),
        body: Column(
          children: [TabbarWidget(), Expanded(child: TabbarviewWidget())],
        ),

        floatingActionButton: FloatingWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
