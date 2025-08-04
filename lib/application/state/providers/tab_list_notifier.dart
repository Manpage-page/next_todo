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
    state = const AsyncLoading(); // 状態を読み込み中にして...
    await ref.read(todoRepositoryProvider).saveTabs(newList); //newListを保存する
    state = AsyncData(newList);
    final sel = ref.read(selectedIndexNotifierProvider);
    if (sel >= newList.length) {
      ref
          .read(selectedIndexNotifierProvider.notifier)
          .update(newList.length - 1);
    }
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    if (state is! AsyncData) return; // データが無ければ何もしない
    var list = [...state.asData!.value];
    final selected = ref.read(selectedIndexNotifierProvider);
    final selectedTitle = list[selected];

    // コピペ
    if (newIndex > oldIndex) newIndex -= 1;
    //タブ削除でインデックスが範囲外になりエラーになるのを防止
    newIndex = newIndex.clamp(0, list.length - 1);

    //並べ替え実行
    final moved = list.removeAt(oldIndex);
    list.insert(newIndex, moved);

    //永続化とstate更新
    state = const AsyncLoading();
    await ref.read(todoRepositoryProvider).saveTabs(list);
    state = AsyncData(list);

    //選択中のタブの新しい位置を取得する
    final newselected = list.indexOf(selectedTitle);
    ref.read(selectedIndexNotifierProvider.notifier).update(newselected);
  }

  Future<void> renameTab({
    required String oldName,
    required String newName,
  }) async {
    //線形探索で選択した名前(oldname)と一致するものを入力した名前(newname)に変更
    final list = [
      for (final t in state.asData!.value) t == oldName ? newName : t,
    ];
    state = const AsyncLoading();
    await ref.read(todoRepositoryProvider).saveTabs(list);
    state = AsyncData(list);
  }
}
