import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:next_todo/application/state/providers/selected_index_notifier.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';

//画面上部のタブバーを管理するwidget
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
          //タブ追加時のダイアログ
          showDialog(
            context: context,
            builder: (context) {
              String tabName = '';
              return AlertDialog(
                title: const Text('タブを追加'),
                content: TextField(
                  autofocus: true,
                  onChanged: (value) => tabName = value,
                  decoration: const InputDecoration(hintText: '新しいタブ名を入力'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('キャンセル'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (tabName.trim().isNotEmpty) {
                        ref
                            .read(tabListNotifierProvider.notifier)
                            .addTab(tabName.trim());
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('追加'),
                  ),
                ],
              );
            },
          );
        } else {
          ref.read(selectedIndexNotifierProvider.notifier).update(index);
        }
      },
    );
  }
}
