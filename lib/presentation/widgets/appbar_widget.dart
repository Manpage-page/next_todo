import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:next_todo/presentation/widgets/todo_search_delegate.dart';

class AppbarWidget extends ConsumerWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); //  高さ指定が必須

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppColors.grey,
      iconTheme: IconThemeData(color: AppColors.emeraldgreen),
      actions: [
        //検索ボタン
        IconButton(
          onPressed: () {
            print('検索ボタンを押しました');
            showSearch(context: context, delegate: TodoSearchDelegate(ref));
          },
          icon: Icon(Icons.search),
        ),
        //設定ボタン
        /*IconButton(
          onPressed: () {
            print('設定アイコンを押しました');
          },
          icon: Icon(Icons.settings_outlined),
        ),*/
      ],
    );
  }
}
