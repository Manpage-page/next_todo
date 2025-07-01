import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/domain/repository/todo_repository.dart';

/// 実装は外から注入される想定なので throw しておく
final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => throw UnimplementedError('todoRepositoryProvider is not overridden'),
);
