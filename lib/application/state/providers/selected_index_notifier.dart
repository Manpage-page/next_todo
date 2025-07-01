import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:next_todo/application/state/providers/todo_repository_provider.dart';
part 'selected_index_notifier.g.dart';

//選択されているタブのインデックスを取得するためのnotifier
@riverpod
class SelectedIndexNotifier extends _$SelectedIndexNotifier {
  @override
  int build() {
    _load();
    return 0;
  }

  void _load() async {
    final repo = ref.read(todoRepositoryProvider); // 依存注入
    final saved = await repo.loadSelectedIndex();
    if (saved != null) state = saved;
  }

  void update(int newIndex) async {
    state = newIndex;
    final repo = ref.read(todoRepositoryProvider);
    await repo.saveSelectedIndex(newIndex);
  }
}
