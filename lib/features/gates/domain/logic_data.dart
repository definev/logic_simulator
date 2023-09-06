import 'package:fast_immutable_collections/fast_immutable_collections.dart';

typedef Bit = bool;

final class LogicData {
  LogicData(this.length, {required IList<Bit> data}) : _data = data;

  factory LogicData.generate(int length, Bit Function(int index) generator) {
    return LogicData(length, data: IList<Bit>(Iterable.generate(length, generator)));
  }

  factory LogicData.fromBytes(List<Bit> bytes) {
    return LogicData(bytes.length, data: IList(bytes));
  }

  factory LogicData.bit(Bit bit) {
    return LogicData(1, data: IListConst<Bit>([bit]));
  }

  factory LogicData.merge(LogicData a, LogicData b) {
    return LogicData(a.length + b.length, data: IListConst<Bit>([...a.data, ...b.data]));
  }

  final int length;
  final IList<Bit> _data;
  IList<Bit> get data => _data;

  Bit operator [](int index) => _data[index];

  LogicData operator +(LogicData other) => LogicData.merge(this, other);
}

extension IntLogicDataTransformation on int {
  LogicData get logicData {
    return LogicData.fromBytes(bits);
  }
}

extension StringLogicDataTransformation on String {
  LogicData get logicData {
    return LogicData.fromBytes(bits);
  }
}

extension IntToBit on int {
  List<Bit> get bits {
    final str = toRadixString(2);
    return [for (var i = 0; i < str.length; i++) int.parse(str[i], radix: 2) == 1];
  }
}

extension StringToBit on String {
  List<Bit> get bits {
    return [for (var i = 0; i < length; i++) int.parse(this[i], radix: 2) == 1];
  }
}
