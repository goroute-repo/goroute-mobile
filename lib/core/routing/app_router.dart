import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/core/widgets/loading_view.dart';
import 'package:goroute_mobile/features/auth/login_mfa_page.dart';
import 'package:goroute_mobile/features/auth/login_page.dart';
import 'package:goroute_mobile/features/home/home_page.dart';
import 'package:goroute_mobile/features/jobs/job_detail_page.dart';
import 'package:goroute_mobile/features/jobs/jobs_page.dart';
import 'package:goroute_mobile/features/mentor/mentor_models.dart';
import 'package:goroute_mobile/features/mentor/mentor_page.dart';
import 'package:goroute_mobile/features/more/about_page.dart';
import 'package:goroute_mobile/features/more/more_page.dart';
import 'package:goroute_mobile/features/notifications/notifications_page.dart';
import 'package:goroute_mobile/features/roadmap/roadmap_node_page.dart';
import 'package:goroute_mobile/features/roadmap/roadmap_page.dart';
import 'package:goroute_mobile/features/settings/settings_page.dart';
import 'package:goroute_mobile/features/shell/app_shell.dart';
import 'package:goroute_mobile/features/weekly/weekly_plan_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Notifies [GoRouter] when session auth future settles / is invalidated.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this._ref) {
    _ref.listen(sessionAuthProvider, (_, __) => notifyListeners());
  }

  final Ref _ref;
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(sessionAuthProvider);
      final loc = state.matchedLocation;
      final onLogin = loc == '/login' || loc.startsWith('/login/');

      return auth.when(
        loading: () => null,
        error: (_, __) => onLogin ? null : '/login',
        data: (hasSession) {
          if (!hasSession && !onLogin) return '/login';
          if (hasSession && onLogin) return '/app/home';
          if (hasSession && loc == '/app') return '/app/home';
          return null;
        },
      );
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'mfa',
            builder: (context, state) {
              final token = state.extra as String?;
              if (token == null || token.isEmpty) {
                return const LoginPage();
              }
              return LoginMfaPage(tempToken: token);
            },
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/roadmap',
                builder: (context, state) => const RoadmapPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/weekly',
                builder: (context, state) => const WeeklyPlanPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/jobs',
                builder: (context, state) => const JobsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/more',
                builder: (context, state) => const MorePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/app/roadmap/nodes/:slug',
        builder: (context, state) {
          final slug = Uri.decodeComponent(state.pathParameters['slug'] ?? '');
          return RoadmapNodePage(slug: slug);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/app/jobs/:jobId',
        builder: (context, state) {
          final jobId =
              Uri.decodeComponent(state.pathParameters['jobId'] ?? '');
          return JobDetailPage(jobId: jobId);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/app/mentor',
        builder: (context, state) {
          final extra = state.extra;
          return MentorPage(
            extra: extra is MentorRouteExtra ? extra : null,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/app/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/app/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/app/about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: '/boot',
        builder: (context, state) => const Scaffold(body: LoadingView()),
      ),
    ],
  );
});
