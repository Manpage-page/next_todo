// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TabItem _$TabItemFromJson(Map<String, dynamic> json) => _TabItem(
  id: json['id'] as String,
  title: json['title'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TabItemToJson(_TabItem instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'order': instance.order,
};
