import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/presentation/widgets/appbar_widget.dart';
import 'package:next_todo/presentation/widgets/drawers/drawer_widget.dart';
import 'package:next_todo/presentation/widgets/fabs/floating_widget.dart';
import 'package:next_todo/presentation/widgets/tabbar_widget.dart';
import 'package:next_todo/presentation/widgets/tabbarview_widget.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTabs = ref.watch(tabListNotifierProvider);

    return asyncTabs.when(
      loading:
          () => const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          ),

      error:
          (err, _) => Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: Text('エラー: $err')),
          ),

      data: (tabs) {
        // '+'を常に右端に固定する
        final normalTabs = tabs.where((t) => t != '+').toList();
        final fixedTabs = [...normalTabs, '+'];

        return DefaultTabController(
          //tabとtabberviewを管理するためのwidget(lengthやindexの状態を保持)
          key: ValueKey(fixedTabs.length),

          length: fixedTabs.length, //タブの数を指定

          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: const AppbarWidget(),
            drawer: DrawerWidget(),
            body: Column(
              children: [
                TabbarWidget(tabs: fixedTabs), //タブバーを表示

                Expanded(
                  child: TabbarviewWidget(tabs: fixedTabs),
                ), //タブバーに対応するリストを表示
              ],
            ),
            floatingActionButton: const FloatingWidget(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        );
      },
    );
  }
}
