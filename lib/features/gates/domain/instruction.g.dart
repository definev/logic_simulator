// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruction.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AddressInstructionCWProxy {
  AddressInstruction from(int from);

  AddressInstruction fromIndex(int fromIndex);

  AddressInstruction to(int to);

  AddressInstruction toIndex(int toIndex);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AddressInstruction(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AddressInstruction(...).copyWith(id: 12, name: "My name")
  /// ````
  AddressInstruction call({
    int? from,
    int? fromIndex,
    int? to,
    int? toIndex,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAddressInstruction.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAddressInstruction.copyWith.fieldName(...)`
class _$AddressInstructionCWProxyImpl implements _$AddressInstructionCWProxy {
  const _$AddressInstructionCWProxyImpl(this._value);

  final AddressInstruction _value;

  @override
  AddressInstruction from(int from) => this(from: from);

  @override
  AddressInstruction fromIndex(int fromIndex) => this(fromIndex: fromIndex);

  @override
  AddressInstruction to(int to) => this(to: to);

  @override
  AddressInstruction toIndex(int toIndex) => this(toIndex: toIndex);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AddressInstruction(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AddressInstruction(...).copyWith(id: 12, name: "My name")
  /// ````
  AddressInstruction call({
    Object? from = const $CopyWithPlaceholder(),
    Object? fromIndex = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? toIndex = const $CopyWithPlaceholder(),
  }) {
    return AddressInstruction(
      from: from == const $CopyWithPlaceholder() || from == null
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as int,
      fromIndex: fromIndex == const $CopyWithPlaceholder() || fromIndex == null
          ? _value.fromIndex
          // ignore: cast_nullable_to_non_nullable
          : fromIndex as int,
      to: to == const $CopyWithPlaceholder() || to == null
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as int,
      toIndex: toIndex == const $CopyWithPlaceholder() || toIndex == null
          ? _value.toIndex
          // ignore: cast_nullable_to_non_nullable
          : toIndex as int,
    );
  }
}

extension $AddressInstructionCopyWith on AddressInstruction {
  /// Returns a callable class that can be used as follows: `instanceOfAddressInstruction.copyWith(...)` or like so:`instanceOfAddressInstruction.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AddressInstructionCWProxy get copyWith =>
      _$AddressInstructionCWProxyImpl(this);
}
