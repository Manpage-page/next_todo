// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tabListNotifierHash() => r'0f797d500b73cdb0526d524b52ac3c62ba26600d';

/// タブ一覧を永続化付きで管理する AsyncNotifier 版
///
/// Copied from [TabListNotifier].
@ProviderFor(TabListNotifier)
final tabListNotifierProvider =
    AutoDisposeAsyncNotifierProvider<TabListNotifier, List<String>>.internal(
      TabListNotifier.new,
      name: r'tabListNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$tabListNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TabListNotifier = AutoDisposeAsyncNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
