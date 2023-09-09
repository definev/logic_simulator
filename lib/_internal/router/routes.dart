import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logic_simulator/features/editor/views/editor_view.dart';
import 'package:logic_simulator/features/gates/domain/custom_gate.dart';

part 'routes.g.dart';

@TypedGoRoute<EditorRouteData>(path: '/editor')
class EditorRouteData extends GoRouteData {
  EditorRouteData({this.$extra});

  final CustomGate? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditorView(gate: $extra);
  }
}

@TypedGoRoute<HomeRouteData>(path: '/')
class HomeRouteData extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
