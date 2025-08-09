import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:next_todo/presentation/widgets/drawers/editable_tile.dart';

class TabReorderScreen extends ConsumerStatefulWidget {
  const TabReorderScreen({super.key});

  @override
  ConsumerState<TabReorderScreen> createState() => _TabReorderScreenState();
}

class _TabReorderScreenState extends ConsumerState<TabReorderScreen> {
  List<String> _cache = const [];

  @override
  Widget build(BuildContext context) {
    final tabsAsync = ref.watch(tabListNotifierProvider);

    //data のときはキャッシュ更新, それ以外はキャッシュを使う
    final tabs = tabsAsync.maybeWhen(
      data: (v) {
        _cache = v;
        return v;
      },
      orElse: () => _cache,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'リストの並び替え・編集',
          style: TextStyle(color: AppColors.emeraldgreen),
        ),
        elevation: 0,
      ),

      //loading分岐を消し、常にリストを描画
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '項目をタップするとリスト名を編集できます',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.only(bottom: 32),
              itemCount: tabs.length,
              onReorder:
                  (oldIdx, newIdx) => ref
                      .read(tabListNotifierProvider.notifier)
                      .reorder(oldIdx, newIdx),
              proxyDecorator:
                  (child, index, animation) => // 任意: ドラッグ中の見た目
                      Material(
                    color: Colors.transparent,
                    elevation: 0,
                    child: child,
                  ),
              itemBuilder:
                  (context, i) => EditableTile(
                    key: ValueKey(tabs[i]),
                    index: i,
                    title: tabs[i],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
