import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:next_todo/application/state/providers/selected_index_notifier.dart';
part 'tab_list_notifier.g.dart';

@riverpod
class TabListNotifier extends _$TabListNotifier {
  //_basetabsを定義し、どのような処理でも+ボタンの最右配置を可能にした
  List<String> _baseTabs = ['Todo', '使い方'];

  @override
  List<String> build() {
    return [..._baseTabs, '+'];
  }

  //Tabを追加するメソッド
  void addTab(String tabName) {
    _baseTabs = [..._baseTabs, tabName];
    state = [..._baseTabs, '+'];

    //新しいタブを追加したらインデックスも更新
    final newIndex = _baseTabs.length - 1;
    ref.read(selectedIndexNotifierProvider.notifier).update(newIndex);
  }

  //選択されたTabを削除する
  void removeTab(String tabName) {
    state = state.where((tab) => tab != tabName).toList();
  }
}
