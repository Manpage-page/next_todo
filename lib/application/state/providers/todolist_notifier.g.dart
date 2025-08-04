// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todolist_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todoListNotifierHash() => r'dd109f1c07bc55554d8cc2bf3c6a55b24ddf4b3d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$TodoListNotifier
    extends BuildlessAutoDisposeNotifier<List<Todo>> {
  late final String tabTitle;

  List<Todo> build(String tabTitle);
}

/// See also [TodoListNotifier].
@ProviderFor(TodoListNotifier)
const todoListNotifierProvider = TodoListNotifierFamily();

/// See also [TodoListNotifier].
class TodoListNotifierFamily extends Family<List<Todo>> {
  /// See also [TodoListNotifier].
  const TodoListNotifierFamily();

  /// See also [TodoListNotifier].
  TodoListNotifierProvider call(String tabTitle) {
    return TodoListNotifierProvider(tabTitle);
  }

  @override
  TodoListNotifierProvider getProviderOverride(
    covariant TodoListNotifierProvider provider,
  ) {
    return call(provider.tabTitle);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'todoListNotifierProvider';
}

/// See also [TodoListNotifier].
class TodoListNotifierProvider
    extends AutoDisposeNotifierProviderImpl<TodoListNotifier, List<Todo>> {
  /// See also [TodoListNotifier].
  TodoListNotifierProvider(String tabTitle)
    : this._internal(
        () => TodoListNotifier()..tabTitle = tabTitle,
        from: todoListNotifierProvider,
        name: r'todoListNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$todoListNotifierHash,
        dependencies: TodoListNotifierFamily._dependencies,
        allTransitiveDependencies:
            TodoListNotifierFamily._allTransitiveDependencies,
        tabTitle: tabTitle,
      );

  TodoListNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tabTitle,
  }) : super.internal();

  final String tabTitle;

  @override
  List<Todo> runNotifierBuild(covariant TodoListNotifier notifier) {
    return notifier.build(tabTitle);
  }

  @override
  Override overrideWith(TodoListNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: TodoListNotifierProvider._internal(
        () => create()..tabTitle = tabTitle,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tabTitle: tabTitle,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TodoListNotifier, List<Todo>>
  createElement() {
    return _TodoListNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TodoListNotifierProvider && other.tabTitle == tabTitle;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tabTitle.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TodoListNotifierRef on AutoDisposeNotifierProviderRef<List<Todo>> {
  /// The parameter `tabTitle` of this provider.
  String get tabTitle;
}

class _TodoListNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<TodoListNotifier, List<Todo>>
    with TodoListNotifierRef {
  _TodoListNotifierProviderElement(super.provider);

  @override
  String get tabTitle => (origin as TodoListNotifierProvider).tabTitle;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
