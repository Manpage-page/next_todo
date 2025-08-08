import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:next_todo/application/state/providers/selected_index_notifier.dart';

import 'package:next_todo/presentation/widgets/add_tab_sheet.dart';

//画面上部のタブバーを管理するwidget
class TabbarWidget extends ConsumerWidget {
  const TabbarWidget({super.key, required this.tabs});
  final List<String> tabs;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<int>(selectedIndexNotifierProvider, (prev, next) {
      final controller = DefaultTabController.maybeOf(context);

      if (controller == null) return; // DefaultTabController が無ければ何もしない
      final clamped = next.clamp(
        0,
        (tabs.length - 1).clamp(0, tabs.length),
      ); // 安全に範囲内へ
      if (controller.index != clamped) {
        controller.animateTo(clamped); // Tab をアニメーションで移動
      }
    });

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
          //タブ追加時のダイアログ

          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return const AddTabSheet();
            },
          );
        } else {
          ref.read(selectedIndexNotifierProvider.notifier).update(index);
          final controller = DefaultTabController.maybeOf(context);
          if (controller != null && controller.index != index) {
            controller.animateTo(index);
          }
        }
      },
    );
  }
}
