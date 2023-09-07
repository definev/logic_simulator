typedef Bit = bool;

final class LogicData {
  const LogicData(this.length, {required List<Bit> data}) : _data = data;

  factory LogicData.generate(int length, Bit Function(int index) generator) {
    return LogicData(length, data: List.generate(length, generator));
  }

  factory LogicData.fromBits(List<Bit> bits) {
    return LogicData(bits.length, data: bits);
  }

  factory LogicData.bit(Bit bit) {
    return LogicData(1, data: [bit]);
  }

  factory LogicData.merge(LogicData a, LogicData b) {
    return LogicData(a.length + b.length, data: [...a.data, ...b.data]);
  }

  final int length;
  final List<Bit> _data;
  List<Bit> get data => _data;

  Bit operator [](int index) => _data[index];
  operator []=(int index, Bit value) => _data[index] = value;

  LogicData operator +(LogicData other) => LogicData.merge(this, other);

  @override
  operator ==(Object? other) {
    if (other is LogicData) return other._data == _data;
    return false;
  }

  @override
  int get hashCode => _data.hashCode;
}

extension IntLogicDataTransformation on int {
  LogicData get logicData {
    return LogicData.fromBits(bits);
  }
}

extension StringLogicDataTransformation on String {
  LogicData get logicData {
    return LogicData.fromBits(bits);
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
