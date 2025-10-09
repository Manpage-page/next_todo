import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:next_todo/application/state/providers/todo_repository_provider.dart';
import 'package:next_todo/application/state/providers/selected_index_notifier.dart';
part 'tab_list_notifier.g.dart';

//なんかメソッドでnewlistとlistと謎に分かれてるので読み直して要修正

/// タブ一覧を永続化付きで管理する AsyncNotifier 版
@riverpod
class TabListNotifier extends _$TabListNotifier {
  // build : 起動時に SharedPreferences からタブをロード
  // 戻り値を FutureOr にすることで AsyncNotifier として動作

  @override
  FutureOr<List<String>> build() async {
    //アプリ起動時に保存されたタブ一覧リストを読み込む
    final repo = ref.read(todoRepositoryProvider);
    final loaded = await repo.loadTabs(); // タブのリストをloadedに代入

    return loaded.where((e) => e != '+').toList(); // これが初期タブリスト
  }

  //タブを追加して保存
  Future<void> addTab(String tab) async {
    //タブを追加して保存
    //タブ一覧が読み込み中やエラーだったら、空リストとして扱う
    final current = state.asData?.value ?? [];
    final newList = [...current, tab];

    /*
    stateはAsyncValue<List<String>>型
    AsyncLoading():読み込み中の状態
    AsyncData(data):データがある状態(表示可能)
    AsyncError(error):エラー状態（表示エラー）
    */
    state = const AsyncLoading(); //状態を読み込み中にして...
    await ref.read(todoRepositoryProvider).saveTabs(newList); //newListを保存する

    // 保存完了後に Data で更新
    state = AsyncData(newList);
  }

  Future<void> removeTab(String tab) async {
    //タブを削除して保存
    //タブ一覧が読み込み中やエラーだったら、空リストとして扱う
    final current = state.asData?.value ?? [];
    final newList = current.where((t) => t != tab).toList();
    final ensuredList = newList.isEmpty ? ['Todo'] : newList;

    state = const AsyncLoading(); // 状態を読み込み中にして...
    await ref
        .read(todoRepositoryProvider)
        .saveTabs(ensuredList); // ensuredListを保存する
    state = AsyncData(ensuredList);
    final sel = ref.read(selectedIndexNotifierProvider);
    if (sel >= ensuredList.length) {
      ref
          .read(selectedIndexNotifierProvider.notifier)
          .update(ensuredList.length - 1);
    }
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final current = state.value ?? const <String>[];
    var list = [...current];
    if (oldIndex == newIndex || list.isEmpty) return;

    final selected = ref.read(selectedIndexNotifierProvider);
    final selectedTitle =
        (selected >= 0 && selected < list.length) ? list[selected] : null;

    if (newIndex > oldIndex) newIndex -= 1;
    newIndex = newIndex.clamp(0, list.length - 1);

    final moved = list.removeAt(oldIndex);
    list.insert(newIndex, moved);

    // 楽観的更新
    state = AsyncData(list);

    if (selectedTitle != null) {
      final newSelected = list.indexOf(selectedTitle);
      ref.read(selectedIndexNotifierProvider.notifier).update(newSelected);
    }

    // 裏で保存, 失敗したら前回値を保持したままエラー化
    unawaited(
      ref.read(todoRepositoryProvider).saveTabs(list).catchError((e, st) {
        state = AsyncError<List<String>>(e, st).copyWithPrevious(state);
      }),
    );
  }

  Future<void> renameTab({
    required String oldName,
    required String newName,
  }) async {
    //線形探索で選択した名前(oldname)と一致するものを入力した名前(newname)に変更
    final current = state.value;
    if (current == null) {
      return;
    }
    final list = [
      for (final t in current) t == oldName ? newName : t,
    ];
    state = const AsyncLoading();
    await ref.read(todoRepositoryProvider).saveTabs(list);
    state = AsyncData(list);
  }
}
