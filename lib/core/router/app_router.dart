import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/app_shell.dart';
import '../../features/dashboard/dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home',    builder: (c, s) => const DashboardScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/empire',  builder: (c, s) => const PlaceholderScreen(label: 'Empire')),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/finance', builder: (c, s) => const PlaceholderScreen(label: 'Finance')),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/world',   builder: (c, s) => const PlaceholderScreen(label: 'World')),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/profile', builder: (c, s) => const PlaceholderScreen(label: 'Profile')),
          ]),
        ],
      ),
    ],
  );
});
