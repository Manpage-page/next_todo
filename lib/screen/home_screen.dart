import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:next_todo/constants/colors.dart';
import 'package:next_todo/widgets/appbar_widget.dart';
import 'package:next_todo/widgets/drawer_widget.dart';
import 'package:next_todo/widgets/floating_widget.dart';
import 'package:next_todo/widgets/tabbar_widget.dart';
import 'package:next_todo/widgets/tabbarview_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3, // タブの数
      child: Scaffold(
        backgroundColor: Colors.black, //背景色
        appBar: const AppbarWidget(), //AppBar
        drawer: DrawerWidget(), //drawer
        body: Column(
          children: [TabbarWidget(), Expanded(child: TabbarviewWidget())],
        ), //タブ

        floatingActionButton: FloatingWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
