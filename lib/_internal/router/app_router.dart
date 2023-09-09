import 'package:go_router/go_router.dart';
import 'package:logic_simulator/_internal/router/routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    routes: $appRoutes,
    initialLocation: EditorRouteData().location,
  );
}
