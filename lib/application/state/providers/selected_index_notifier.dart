import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'selected_index_notifier.g.dart';

//選択されているタブのインデックスを取得するためのnotifier
@riverpod
class SelectedIndexNotifier extends _$SelectedIndexNotifier {
  @override
  int build() {
    return 0;
  }

  void update(int newIndex) {
    state = newIndex;
  }
}
