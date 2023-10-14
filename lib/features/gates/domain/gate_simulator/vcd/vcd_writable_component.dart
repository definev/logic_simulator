import 'package:dart_vcd/dart_vcd.dart';
import 'package:logic_simulator/features/gates/domain/gate_simulator/component/component.dart';

class InstanceIndex {
  const InstanceIndex({required this.instance, required this.port});

  final int instance;
  final int port;

  @override
  String toString() => 'InstanceIndex(instance: $instance, port: $port)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InstanceIndex && other.instance == instance && other.port == port;
  }

  @override
  int get hashCode => Object.hash(instance, port);

  InstanceIndex copyWith({
    int? instance,
    int? port,
  }) {
    return InstanceIndex(
      instance: instance ?? this.instance,
      port: port ?? this.port,
    );
  }
}

class VCDHandler {
  final Map<InstanceIndex, IDCode> id;

  VCDHandler({required this.id});
}

mixin VCDWritable on Component {
  VCDHandler writeInternalComponent(VCDWriter writer, int scope) => VCDHandler(id: {});

  void writeInternalSignals(VCDWriter writer, int scope, VCDHandler handler);
}
