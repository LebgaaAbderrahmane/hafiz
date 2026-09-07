import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/forgot_password_view.dart';
import '../../features/auth/domain/repositories/auth_provider.dart';
import '../../features/students/presentation/views/student_list_view.dart';
import '../../features/students/presentation/views/student_profile_view.dart';
import '../../features/students/presentation/views/add_student_view.dart';
import '../../features/teachers/presentation/views/teacher_list_view.dart';
import '../../features/teachers/presentation/views/teacher_profile_view.dart';
import '../../features/classes/presentation/views/class_list_view.dart';
import '../../features/classes/presentation/views/class_detail_view.dart';
import '../../features/quran/presentation/views/quran_browse_view.dart';
import '../theme/theme.dart';

/// App Router configuration.
///
/// Uses go_router for declarative routing.
/// Auth guard via redirect.
/// ShellRoute for sidebar navigation (admin).
/// StatefulShellRoute for bottom navigation (teacher/parent).
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/forgot-password';

      // Redirect to login if not authenticated and not on auth route
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      // Redirect to dashboard if authenticated and on auth route
      if (isLoggedIn && isAuthRoute) {
        return '/dashboard';
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(authState),
    routes: [
      // ── Auth Routes ──
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordView(),
      ),

      // ── Onboarding ──
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const _PlaceholderPage(title: 'Onboarding'),
      ),

      // ── Admin Shell (Sidebar) ──
      ShellRoute(
        builder: (context, state, child) => _AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const _PlaceholderPage(title: 'Dashboard'),
          ),
          GoRoute(
            path: '/students',
            name: 'students',
            builder: (context, state) => const StudentListView(),
            routes: [
              GoRoute(
                path: 'add',
                name: 'addStudent',
                builder: (context, state) => const AddStudentView(),
              ),
              GoRoute(
                path: ':id',
                name: 'studentProfile',
                builder: (context, state) => StudentProfileView(
                  studentId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/teachers',
            name: 'teachers',
            builder: (context, state) => const TeacherListView(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'teacherProfile',
                builder: (context, state) => TeacherProfileView(
                  teacherId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/classes',
            name: 'classes',
            builder: (context, state) => const ClassListView(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'classDetail',
                builder: (context, state) => ClassDetailView(
                  classId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/attendance',
            name: 'attendance',
            builder: (context, state) => const _PlaceholderPage(title: 'Attendance'),
          ),
          GoRoute(
            path: '/quran-progress',
            name: 'quranProgress',
            builder: (context, state) => const QuranBrowseView(),
          ),
          GoRoute(
            path: '/assessments',
            name: 'assessments',
            builder: (context, state) => const _PlaceholderPage(title: 'Assessments'),
          ),
          GoRoute(
            path: '/schedule',
            name: 'schedule',
            builder: (context, state) => const _PlaceholderPage(title: 'Schedule'),
          ),
          GoRoute(
            path: '/reports',
            name: 'reports',
            builder: (context, state) => const _PlaceholderPage(title: 'Reports'),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const _PlaceholderPage(title: 'Settings'),
          ),
        ],
      ),

      // ── Teacher Shell (Bottom Nav) ──
      ShellRoute(
        builder: (context, state, child) => _TeacherShell(child: child),
        routes: [
          GoRoute(
            path: '/teacher/today',
            name: 'teacherToday',
            builder: (context, state) => const _PlaceholderPage(title: 'Today'),
          ),
          GoRoute(
            path: '/teacher/students',
            name: 'teacherStudents',
            builder: (context, state) => const _PlaceholderPage(title: 'My Students'),
          ),
          GoRoute(
            path: '/teacher/attendance',
            name: 'teacherAttendance',
            builder: (context, state) => const _PlaceholderPage(title: 'Attendance'),
          ),
          GoRoute(
            path: '/teacher/revision',
            name: 'teacherRevision',
            builder: (context, state) => const _PlaceholderPage(title: 'Revision'),
          ),
        ],
      ),

      // ── Parent Shell (Bottom Nav) ──
      ShellRoute(
        builder: (context, state, child) => _ParentShell(child: child),
        routes: [
          GoRoute(
            path: '/parent/home',
            name: 'parentHome',
            builder: (context, state) => const _PlaceholderPage(title: 'Home'),
          ),
          GoRoute(
            path: '/parent/progress',
            name: 'parentProgress',
            builder: (context, state) => const _PlaceholderPage(title: 'Progress'),
          ),
          GoRoute(
            path: '/parent/schedule',
            name: 'parentSchedule',
            builder: (context, state) => const _PlaceholderPage(title: 'Schedule'),
          ),
          GoRoute(
            path: '/parent/messages',
            name: 'parentMessages',
            builder: (context, state) => const _PlaceholderPage(title: 'Messages'),
          ),
        ],
      ),
    ],
  );
});

/// Helper to convert a Stream to a Listenable for go_router's refreshListenable.
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

// ── Placeholder Pages (to be replaced) ──

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}

// ── Shell Layouts ──

class _AdminShell extends StatelessWidget {
  const _AdminShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // TODO: Replace with AppSidebar widget
          Container(
            width: 248,
            color: Theme.of(context).colorScheme.surface,
            child: const Center(child: Text('Sidebar')),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _TeacherShell extends StatelessWidget {
  const _TeacherShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Students'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.replay), label: 'Revision'),
        ],
      ),
    );
  }
}

class _ParentShell extends StatelessWidget {
  const _ParentShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
        ],
      ),
    );
  }
}
