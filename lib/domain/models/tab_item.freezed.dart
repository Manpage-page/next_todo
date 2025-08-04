// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tab_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TabItem {

 String get id;// UUID
 String get title; int get order;
/// Create a copy of TabItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TabItemCopyWith<TabItem> get copyWith => _$TabItemCopyWithImpl<TabItem>(this as TabItem, _$identity);

  /// Serializes this TabItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TabItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,order);

@override
String toString() {
  return 'TabItem(id: $id, title: $title, order: $order)';
}


}

/// @nodoc
abstract mixin class $TabItemCopyWith<$Res>  {
  factory $TabItemCopyWith(TabItem value, $Res Function(TabItem) _then) = _$TabItemCopyWithImpl;
@useResult
$Res call({
 String id, String title, int order
});




}
/// @nodoc
class _$TabItemCopyWithImpl<$Res>
    implements $TabItemCopyWith<$Res> {
  _$TabItemCopyWithImpl(this._self, this._then);

  final TabItem _self;
  final $Res Function(TabItem) _then;

/// Create a copy of TabItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? order = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TabItem implements TabItem {
  const _TabItem({required this.id, required this.title, this.order = 0});
  factory _TabItem.fromJson(Map<String, dynamic> json) => _$TabItemFromJson(json);

@override final  String id;
// UUID
@override final  String title;
@override@JsonKey() final  int order;

/// Create a copy of TabItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TabItemCopyWith<_TabItem> get copyWith => __$TabItemCopyWithImpl<_TabItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TabItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TabItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,order);

@override
String toString() {
  return 'TabItem(id: $id, title: $title, order: $order)';
}


}

/// @nodoc
abstract mixin class _$TabItemCopyWith<$Res> implements $TabItemCopyWith<$Res> {
  factory _$TabItemCopyWith(_TabItem value, $Res Function(_TabItem) _then) = __$TabItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, int order
});




}
/// @nodoc
class __$TabItemCopyWithImpl<$Res>
    implements _$TabItemCopyWith<$Res> {
  __$TabItemCopyWithImpl(this._self, this._then);

  final _TabItem _self;
  final $Res Function(_TabItem) _then;

/// Create a copy of TabItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? order = null,}) {
  return _then(_TabItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
