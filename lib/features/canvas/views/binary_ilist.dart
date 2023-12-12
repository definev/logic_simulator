import 'package:fast_immutable_collections/fast_immutable_collections.dart';

typedef DistanceFunction<T> = int Function(T object);

class BinaryIList<T> {
  BinaryIList({
    required IList<T> list,
    required int Function(T a, T b) compare,
    bool sorted = false,
  })  : _list = list,
        _compare = compare {
    if (sorted == false) _sort();
  }

  IList<T> _list;
  IList<T> get list => _list;
  final Comparator<T> _compare;

  void _sort() {
    _list = _list.sort(_compare);
  }

  void _selectionSort() {
    final list = _list.unlockLazy;

    for (var i = 0; i < list.length; i += 1) {
      var min = i;
      for (var j = i + 1; j < list.length; j += 1) {
        if (_compare(list[j], list[min]) < 0) {
          min = j;
        }
      }
      if (min != i) {
        final temp = _list[i];
        list[i] = _list[min];
        list[min] = temp;
      }
    }

    _list = list.lock;
  }

  void add(T element) {
    _list = _list.add(element);
    _selectionSort();
  }

  void addAll(Iterable<T> elements) {
    _list = _list.addAll(elements);
    _selectionSort();
  }

  void remove(T element) {
    _list = _list.remove(element);
    _selectionSort();
  }

  void removeAll(Iterable<T> elements) {
    _list = _list.removeAll(elements);
    _selectionSort();
  }

  BinaryIList<T> slice(int start, int end) {
    return BinaryIList(
      list: _list.sublist(start, end),
      compare: _compare,
      sorted: true,
    );
  }

  ({int min, int mid, int max})? _binarySearch(int initMin, int initMax, DistanceFunction<T> test) {
    if (initMin == initMax) {
      return (min: initMin, mid: initMin, max: initMin);
    }
    while (initMin < initMax) {
      final mid = initMin + ((initMax - initMin) >> 1);
      final element = _list[mid];
      final compare = test(element);
      if (compare == 0) return (min: initMin, max: initMax, mid: mid);
      if (compare < 0) initMin = mid + 1;
      if (compare > 0) initMax = mid;
    }

    return null;
  }

  BinaryIList<T>? whereIndexed(DistanceFunction<T> test) {
    int min = 0;
    int max = _list.length;
    bool found = false;
    int pivot = 0;

    while (true) {
      switch (found) {
        case true:
          int left = pivot;
          while (left >= 0) {
            left = left - 1;
            if (left < 0) {
              left += 1;
              break;
            }
            final element = _list[left];
            final compare = test(element);
            if (compare == 0) continue;
            left += 1;
            break;
          }

          int right = pivot;
          while (right < _list.length) {
            right = right + 1;
            if (right == _list.length) {
              right -= 1;
              break;
            }
            final element = _list[right];
            final compare = test(element);
            if (compare == 0) continue;
            right -= 1;
            break;
          }

          return slice(left, right);

        case false:
          if (_binarySearch(min, max, test) case final result?) {
            final (min: _, max: _, :mid) = result;
            pivot = mid;
            found = true;
            continue;
          }
          return null;
      }
    }
  }
}

extension IListToBinaryIListX<T> on IList<T> {
  BinaryIList<T> binaryIList(Comparator<T> compare) => BinaryIList(list: this, compare: compare);
}


extension BinaryIListX<T> on BinaryIList<T> {
  BinaryIList<T> binaryIList(Comparator<T> compare) => BinaryIList(list: list, compare: compare, sorted: false);
}