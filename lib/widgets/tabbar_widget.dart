import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:next_todo/providers/tab_list_notifier.dart';

class TabbarWidget extends ConsumerWidget {
  const TabbarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = ref.watch(tabListNotifierProvider);

    return TabBar(
      indicatorColor: AppColors.emeraldgreen,
      labelColor: AppColors.emeraldgreen,
      unselectedLabelColor: Colors.white,
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
        if (tabs[index] == '+') {
          // タブ追加処理
          print('tab追加ボタンが押されました');
        }
      },
    );
  }
}
