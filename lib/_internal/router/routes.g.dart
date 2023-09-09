// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $editorRouteData,
      $homeRouteData,
    ];

RouteBase get $editorRouteData => GoRouteData.$route(
      path: '/editor',
      factory: $EditorRouteDataExtension._fromState,
    );

extension $EditorRouteDataExtension on EditorRouteData {
  static EditorRouteData _fromState(GoRouterState state) => EditorRouteData(
        $extra: state.extra as CustomGate?,
      );

  String get location => GoRouteData.$location(
        '/editor',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $homeRouteData => GoRouteData.$route(
      path: '/',
      factory: $HomeRouteDataExtension._fromState,
    );

extension $HomeRouteDataExtension on HomeRouteData {
  static HomeRouteData _fromState(GoRouterState state) => HomeRouteData();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
