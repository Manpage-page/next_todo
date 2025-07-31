import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:next_todo/application/state/providers/todo_repository_provider.dart';
part 'tab_list_notifier.g.dart';

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
    return loaded; // これが初期タブリスト
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
  }
}
