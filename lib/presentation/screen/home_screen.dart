import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/presentation/widgets/appbar_widget.dart';
import 'package:next_todo/presentation/widgets/drawers/drawer_widget.dart';
import 'package:next_todo/presentation/widgets/fabs/floating_widget.dart';
import 'package:next_todo/presentation/widgets/tabbar_widget.dart';
import 'package:next_todo/presentation/widgets/tabbarview_widget.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';
import 'package:next_todo/presentation/widgets/add_tab_sheet.dart';
import 'package:next_todo/application/state/providers/selected_index_notifier.dart';

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
        // '+' を取り除く（タブ自体には + を入れない）
        final normalTabs = tabs.where((t) => t != '+').toList();

        // TabBar に渡す配列は 0 長さだと困る
        final tabsForBar = normalTabs.isEmpty ? [''] : normalTabs;

        // controller length は tabsForBar.length（最低1）
        final controllerLength = tabsForBar.length;

        final rawSelectedIndex = ref.read(selectedIndexNotifierProvider);
        final safeIndex = rawSelectedIndex.clamp(0, controllerLength - 1);

        if (safeIndex != rawSelectedIndex) {
          // 補正が必要なら provider を更新（この update が別箇所の rebuild を引き起こすが安全）
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(selectedIndexNotifierProvider.notifier).update(safeIndex);
          });
        }

        return DefaultTabController(
          key: ValueKey(controllerLength), // タブ数が変わったら再生成
          length: controllerLength,
          initialIndex: safeIndex,
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: const AppbarWidget(),
            drawer: DrawerWidget(),
            body: Column(
              children: [
                // Row で TabBar と + ボタンを並べる
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      // タブバー（左側に伸ばす）
                      Expanded(child: TabbarWidget(tabs: tabsForBar)),

                      // 右端に + ボタン
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const AddTabSheet(),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // TabBarView（タブに対応する中身）
                Expanded(child: TabbarviewWidget(tabs: tabsForBar)),
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















/*
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
*/