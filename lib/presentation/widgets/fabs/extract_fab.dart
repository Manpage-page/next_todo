import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:next_todo/presentation/widgets/gemini_widget.dart/add_from_text_sheet.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';
import 'package:next_todo/application/state/providers/selected_index_notifier.dart';

//extractボトムシートを開くためのFAB
class ExtractFAB extends ConsumerWidget {
  const ExtractFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      heroTag: 'extract',

      onPressed: () async {
        final tab = ref.read(tabListNotifierProvider).value ?? [];
        final selectedIndex = ref.read(selectedIndexNotifierProvider);

        //現在のタブを読み込む
        final currentTab =
            (selectedIndex >= 0 && selectedIndex < tab.length)
                ? tab[selectedIndex]
                : '';

        // AddFromTextSheet をモーダルで開く
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: AppColors.grey,
          builder: (_) => AddFromTextSheet(currentTab: currentTab),
        );
      },
      backgroundColor: AppColors.grey,
      shape: const CircleBorder(),
      child: Icon(Icons.chat_bubble_outline, color: AppColors.emeraldgreen),
    );

    //デバッグ用の情報を列挙
  }
}
