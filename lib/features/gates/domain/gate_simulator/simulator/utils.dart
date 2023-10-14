import 'package:logic_simulator/features/gates/domain/gate_simulator/bit.dart';

class RepeatInputIterable extends Iterable<List<Bit>> {
  const RepeatInputIterable({
    required this.size,
    required this.repeatTime,
  });

  final int size;
  final int repeatTime;

  @override
  Iterator<List<Bit>> get iterator => RepeatInputIterator(size: size, repeatTime: repeatTime);
}

class RepeatInputIterator implements Iterator<List<Bit>> {
  RepeatInputIterator({
    required this.size,
    required this.repeatTime,
  }) {
    _current = List.generate(size, (index) => Bit.zero);
  }

  final int size;
  final int repeatTime;
  int _currentTime = 0;

  List<Bit> _current = [];

  @override
  List<Bit> get current => _current;

  static List<Bit> _nextInput(List<Bit> input) {
    final nextInput = List.of(input);
    var i = nextInput.length;
    var carry = true;
    while (carry && i > 0) {
      i -= 1;
      switch (nextInput[i]) {
        case Bit.zero:
          carry = false;
          nextInput[i] = Bit.one;
        case Bit.one:
          carry = true;
          nextInput[i] = Bit.zero;
        case Bit.unknown:
          carry = true;
      }
    }
    return nextInput;
  }

  @override
  bool moveNext() {
    if (_currentTime == repeatTime) {
      _currentTime = 0;
      _current = _nextInput([..._current]);
    }
    _currentTime++;
    return true;
  }
}
