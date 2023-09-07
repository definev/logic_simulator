import 'package:logic_simulator/features/gates/domain/logic_data.dart';

typedef LocatedLogicData = ({LogicData data, int index});

class LogicDataBuilder {
  LogicDataBuilder({required List<LocatedLogicData> slots}) : _slots = slots;

  factory LogicDataBuilder.fromBits(List<Bit> bits) {
    final slots = [for (final bit in bits) (data: LogicData.bit(bit), index: 0)];
    return LogicDataBuilder(slots: slots);
  }

  factory LogicDataBuilder.fromLogicData(LogicData data) {
    final slots = [for (var i = 0; i < data.length; i++) (data: data, index: i)];
    return LogicDataBuilder(slots: slots);
  }

  factory LogicDataBuilder.fromString(String value) {
    final bits = value.bits;
    return LogicDataBuilder.fromBits(bits);
  }

  final List<LocatedLogicData> _slots;

  void updateSlot(int index, LocatedLogicData data) => _slots[index] = data;

  LogicData build() => LogicData.fromBits([for (final (:data, :index) in _slots) data[index]]);
}
