import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/auth/presentation/views/login_view.dart';
import 'package:hafiz/features/auth/presentation/views/forgot_password_view.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';
import 'package:hafiz/features/hifz/presentation/views/hifz_assignment_list_view.dart';
import 'package:hafiz/features/hifz/presentation/views/hifz_assignment_form_view.dart';
import 'package:hafiz/features/notifications/presentation/views/notification_view.dart';
import 'package:hafiz/features/settings/presentation/views/settings_view.dart';
import 'package:hafiz/core/theme/theme.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final authStream = ref.watch(authRepositoryProvider).authStateChanges;

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/forgot-password';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/dashboard';
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authStream),
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordView(),
      ),
      ShellRoute(
        builder: (context, state, child) => _AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const _PlaceholderPage(title: 'لوحة التحكم'),
          ),
          GoRoute(
            path: '/students',
            builder: (context, state) => const _PlaceholderPage(title: 'الطلاب'),
          ),
          GoRoute(
            path: '/teachers',
            builder: (context, state) => const _PlaceholderPage(title: 'المعلمون'),
          ),
          GoRoute(
            path: '/classes',
            builder: (context, state) => const _PlaceholderPage(title: 'الفصول'),
          ),
          GoRoute(
            path: '/hifz/assignments',
            builder: (context, state) => const HifzAssignmentListView(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const HifzAssignmentFormView(),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (context, state) => HifzAssignmentFormView(
                  assignmentId: state.pathParameters['id'],
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationView(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsView(),
          ),
        ],
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final dynamic _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(title, style: AppTextStyles.headlineMedium),
      ),
    );
  }
}

class _AdminShell extends StatelessWidget {
  const _AdminShell({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 248,
            color: AppColors.surface,
            child: Column(
              children: [
                const SizedBox(height: 48),
                Text('حفيظ', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary)),
                const SizedBox(height: 32),
                _navItem(context, 'لوحة التحكم', '/dashboard', Icons.dashboard),
                _navItem(context, 'الطلاب', '/students', Icons.people),
                _navItem(context, 'المعلمون', '/teachers', Icons.person),
                _navItem(context, 'الفصول', '/classes', Icons.class_),
                _navItem(context, 'تعيينات الحفظ', '/hifz/assignments', Icons.book),
                _navItem(context, 'الإشعارات', '/notifications', Icons.notifications),
                _navItem(context, 'الإعدادات', '/settings', Icons.settings),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, String path, IconData icon) {
    final isSelected = GoRouterState.of(context).matchedLocation == path;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () => context.go(path),
    );
  }
}
