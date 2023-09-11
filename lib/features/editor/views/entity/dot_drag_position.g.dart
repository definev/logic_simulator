// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dot_drag_position.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DotDragPositionCWProxy {
  DotDragPosition dot(Offset dot);

  DotDragPosition drag(Offset drag);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DotDragPosition(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DotDragPosition(...).copyWith(id: 12, name: "My name")
  /// ````
  DotDragPosition call({
    Offset? dot,
    Offset? drag,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDotDragPosition.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDotDragPosition.copyWith.fieldName(...)`
class _$DotDragPositionCWProxyImpl implements _$DotDragPositionCWProxy {
  const _$DotDragPositionCWProxyImpl(this._value);

  final DotDragPosition _value;

  @override
  DotDragPosition dot(Offset dot) => this(dot: dot);

  @override
  DotDragPosition drag(Offset drag) => this(drag: drag);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DotDragPosition(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DotDragPosition(...).copyWith(id: 12, name: "My name")
  /// ````
  DotDragPosition call({
    Object? dot = const $CopyWithPlaceholder(),
    Object? drag = const $CopyWithPlaceholder(),
  }) {
    return DotDragPosition(
      dot: dot == const $CopyWithPlaceholder() || dot == null
          ? _value.dot
          // ignore: cast_nullable_to_non_nullable
          : dot as Offset,
      drag: drag == const $CopyWithPlaceholder() || drag == null
          ? _value.drag
          // ignore: cast_nullable_to_non_nullable
          : drag as Offset,
    );
  }
}

extension $DotDragPositionCopyWith on DotDragPosition {
  /// Returns a callable class that can be used as follows: `instanceOfDotDragPosition.copyWith(...)` or like so:`instanceOfDotDragPosition.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DotDragPositionCWProxy get copyWith => _$DotDragPositionCWProxyImpl(this);
}
