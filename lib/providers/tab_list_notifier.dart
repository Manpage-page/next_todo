import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'tab_list_notifier.g.dart';

@riverpod
class TabListNotifier extends _$TabListNotifier {
  List<String> _baseTabs = ['Todo', '使い方'];

  @override
  List<String> build() {
    return [..._baseTabs, '+'];
  }

  //Tabを追加するメソッド
  void addTab(String tabName) {
    _baseTabs = [..._baseTabs, tabName];
    state = [..._baseTabs, '+'];
  }

  //Tabを削除する
  void removeTab(String tabName) {
    state = state.where((tab) => tab != tabName).toList();
  }
}
