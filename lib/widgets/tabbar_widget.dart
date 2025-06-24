import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:next_todo/providers/selected_index_notifier.dart';
import 'package:next_todo/providers/tab_list_notifier.dart';

class TabbarWidget extends ConsumerWidget {
  const TabbarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = ref.watch(tabListNotifierProvider);

    return TabBar(
      indicatorColor: AppColors.emeraldgreen, //選択されているタブの下線部
      labelColor: AppColors.emeraldgreen, //選択中のタブの文字色
      unselectedLabelColor: Colors.white, // 選択されていないタブの色
      isScrollable: true,

      tabs: [
        ...tabs.map((tab) {
          if (tab == '+') {
            return const Tab(icon: Icon(Icons.add));
          } else {
            return Tab(text: tab);
          }
        }),
      ],

      onTap: (index) {
        //+ボタンが押されたらタブを追加し、それ以外はselected_indexを更新する
        if (tabs[index] == '+') {
          ref.read(tabListNotifierProvider.notifier).addTab('新しいタブ');
        } else {
          ref.read(selectedIndexNotifierProvider.notifier).update(index);
        }
      },
    );
  }
}
