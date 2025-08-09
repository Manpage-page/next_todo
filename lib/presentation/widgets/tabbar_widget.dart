import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:next_todo/application/state/providers/selected_index_notifier.dart';

//画面上部のタブバーを管理するwidget
class TabbarWidget extends ConsumerWidget {
  const TabbarWidget({super.key, required this.tabs});
  final List<String> tabs;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TabBar(
      indicatorColor: AppColors.emeraldgreen, //選択されているタブの下線部
      labelColor: AppColors.emeraldgreen, //選択中のタブの文字色
      unselectedLabelColor: Colors.white, // 選択されていないタブの色
      isScrollable: true,

      tabs: [for (final tab in tabs) Tab(text: tab.isEmpty ? null : tab)],

      onTap: (index) {
        ref.read(selectedIndexNotifierProvider.notifier).update(index);
      },
    );
  }
}
