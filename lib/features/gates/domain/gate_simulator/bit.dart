import 'package:dart_vcd/dart_vcd.dart';

enum Bit {
  zero,
  one,
  unknown;

  String get name => switch (this) {
        Bit.zero => '0',
        Bit.one => '1',
        Bit.unknown => '?',
      };
}

extension BitToValueConverter on Bit {
  Value get bitValue => switch (this) {
        Bit.zero => Value.v0,
        Bit.one => Value.v1,
        Bit.unknown => Value.x,
      };
}
