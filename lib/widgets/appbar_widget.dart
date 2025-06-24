import 'package:flutter/material.dart';
import 'package:next_todo/constants/colors.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // ← 高さ指定が必須

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.grey,
      iconTheme: IconThemeData(color: AppColors.emeraldgreen),
      actions: [
        //検索ボタン
        IconButton(
          onPressed: () {
            print('検索ボタンを押しました');
          },
          icon: Icon(Icons.search),
        ),
        //設定ボタン
        IconButton(
          onPressed: () {
            print('設定アイコンを押しました');
          },
          icon: Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}
