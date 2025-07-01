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
        return DefaultTabController(
          length: tabs.length, // ← ここは List<String> なので OK
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: const AppbarWidget(),
            drawer: DrawerWidget(),
            body: Column(
              children: [
                const TabbarWidget(),
                Expanded(child: const TabbarviewWidget()),
              ],
            ),
            floatingActionButton: const FloatingWidget(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        );
      },
    );

    /*DefaultTabController(
      length: asynctabs.length, // タブの数(一応プログラムが動くようにtabsにしているが本来はnormalTabs)
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
    );*/
  }
}
