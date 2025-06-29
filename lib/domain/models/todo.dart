// 1. 必要なパッケージとpartファイルをインポート
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart'; // 生成されるファイル名を指定
part 'todo.g.dart';

// 2. @freezedアノテーションを付ける
@freezed
// 3. abstractクラスにし、with _$クラス名 を追加
abstract class Todo with _$Todo {
  const factory Todo({
    required String title,

    @Default(false) bool isDone, //デフォルト値はfalse
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
