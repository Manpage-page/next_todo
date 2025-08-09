import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/state/providers/selected_index_notifier.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:next_todo/presentation/widgets/drawers/tab_reorder.dart';

//Drawerの中身
class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabsAsync = ref.watch(tabListNotifierProvider);

    return Drawer(
      backgroundColor: Colors.black,

      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          DrawerHeader(
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('メニュー', style: TextStyle(color: Colors.white)),
            ),
          ),
          // _MenuTile(label: 'カレンダー', icon: Icons.calendar_today),
          // _MenuTile(label: '期限付き', icon: Icons.event_note),
          // _MenuTile(label: 'ゴミ箱', icon: Icons.delete),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('作成したリスト', style: TextStyle(color: Colors.white)),
              TextButton(
                //並び替え・編集ボタンで編集画面へ遷移
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TabReorderScreen()),
                  );
                },
                child: const Text(
                  '並び替え・編集',
                  style: TextStyle(color: AppColors.emeraldgreen),
                ),
              ),
            ],
          ),
          tabsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (e, _) =>
                    Text('エラー: $e', style: const TextStyle(color: Colors.red)),
            data:
                (tabs) => Column(
                  children: [
                    for (final t in tabs)
                      ListTile(
                        dense: true,
                        /*leading: const Icon( //いったんICONは無しの方針で
                          Icons.radio_button_off,
                          size: 18,
                          color: Colors.white70,
                        ),*/
                        title: Text(
                          t,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          final idx = tabs.indexOf(t);
                          ref
                              .read(selectedIndexNotifierProvider.notifier)
                              .update(idx);
                          Navigator.pop(context);
                        },
                      ),
                  ],
                ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

//drawerのメニュー項目（まだ未実装）
class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () {}, //画面遷移など
    );
  }
}
