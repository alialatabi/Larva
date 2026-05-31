import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/app_shell.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/auth/onboarding_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/empire/empire_screen.dart';
import '../../features/empire/company_detail_screen.dart';
import '../../features/empire/stock_market_screen.dart';
import '../../features/finance/finance_screen.dart';
import '../../features/world/world_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/notifications/notification_center_screen.dart';
import '../providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);
  return GoRouter(
    initialLocation: '/home',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(path: '/auth',       builder: (c, s) => const AuthScreen()),
      GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
      GoRoute(path: '/notifications', builder: (c, s) => const NotificationCenterScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home',    builder: (c, s) => const DashboardScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/empire',
              builder: (c, s) => const EmpireScreen(),
              routes: [
                GoRoute(
                  path: 'company/:id',
                  builder: (c, s) => CompanyDetailScreen(
                    companyId: int.tryParse(s.pathParameters['id'] ?? '') ?? 1,
                  ),
                ),
                GoRoute(
                  path: 'stocks',
                  builder: (c, s) => const StockMarketScreen(),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/finance', builder: (c, s) => const FinanceScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/world',   builder: (c, s) => const WorldScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
          ]),
        ],
      ),
    ],
  );
});
