import 'package:freezed_annotation/freezed_annotation.dart';
part 'tab_item.freezed.dart';
part 'tab_item.g.dart';

@freezed
abstract class TabItem with _$TabItem {
  const factory TabItem({
    required String id, // UUID
    required String title,
    @Default(0) int order, // 表示順
  }) = _TabItem;

  factory TabItem.fromJson(Map<String, dynamic> json) =>
      _$TabItemFromJson(json);
}
