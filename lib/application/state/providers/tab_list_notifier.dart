import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:next_todo/application/state/providers/todo_repository_provider.dart';
part 'tab_list_notifier.g.dart';

/// タブ一覧を永続化付きで管理する AsyncNotifier 版
@riverpod
class TabListNotifier extends _$TabListNotifier {
  // ────────────────────────────────────────────
  // build : 起動時に SharedPreferences からタブをロード
  // 戻り値を FutureOr にすることで AsyncNotifier として動作
  // ────────────────────────────────────────────
  @override
  FutureOr<List<String>> build() async {
    final repo = ref.read(todoRepositoryProvider);
    final loaded = await repo.loadTabs();
    return loaded; // これが初期タブリスト
  }

  // ────────────────────────────────────────────
  // addTab : タブを追加して保存
  // ────────────────────────────────────────────
  Future<void> addTab(String tab) async {
    // 現在のタブ一覧を取得（Data のときだけ value がある）
    final current = state.asData?.value ?? [];
    final newList = [...current, tab];

    // 一旦ローディング状態にしてから保存
    state = const AsyncLoading();
    await ref.read(todoRepositoryProvider).saveTabs(newList);

    // 保存完了後に Data で更新
    state = AsyncData(newList);
  }

  // ────────────────────────────────────────────
  // removeTab : タブを削除して保存
  // ────────────────────────────────────────────
  Future<void> removeTab(String tab) async {
    final current = state.asData?.value ?? [];
    final newList = current.where((t) => t != tab).toList();

    state = const AsyncLoading();
    await ref.read(todoRepositoryProvider).saveTabs(newList);
    state = AsyncData(newList);
  }
}
