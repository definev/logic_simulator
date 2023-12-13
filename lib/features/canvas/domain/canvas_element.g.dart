// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas_element.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CanvasElementCWProxy {
  CanvasElement id(int id);

  CanvasElement offset(Offset offset);

  CanvasElement isSelected(bool isSelected);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CanvasElement(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CanvasElement(...).copyWith(id: 12, name: "My name")
  /// ````
  CanvasElement call({
    int? id,
    Offset? offset,
    bool? isSelected,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCanvasElement.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCanvasElement.copyWith.fieldName(...)`
class _$CanvasElementCWProxyImpl implements _$CanvasElementCWProxy {
  const _$CanvasElementCWProxyImpl(this._value);

  final CanvasElement _value;

  @override
  CanvasElement id(int id) => this(id: id);

  @override
  CanvasElement offset(Offset offset) => this(offset: offset);

  @override
  CanvasElement isSelected(bool isSelected) => this(isSelected: isSelected);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CanvasElement(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CanvasElement(...).copyWith(id: 12, name: "My name")
  /// ````
  CanvasElement call({
    Object? id = const $CopyWithPlaceholder(),
    Object? offset = const $CopyWithPlaceholder(),
    Object? isSelected = const $CopyWithPlaceholder(),
  }) {
    return CanvasElement(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      offset: offset == const $CopyWithPlaceholder() || offset == null
          ? _value.offset
          // ignore: cast_nullable_to_non_nullable
          : offset as Offset,
      isSelected:
          isSelected == const $CopyWithPlaceholder() || isSelected == null
              ? _value.isSelected
              // ignore: cast_nullable_to_non_nullable
              : isSelected as bool,
    );
  }
}

extension $CanvasElementCopyWith on CanvasElement {
  /// Returns a callable class that can be used as follows: `instanceOfCanvasElement.copyWith(...)` or like so:`instanceOfCanvasElement.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CanvasElementCWProxy get copyWith => _$CanvasElementCWProxyImpl(this);
}
