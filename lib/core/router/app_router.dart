import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/auth/presentation/views/login_view.dart';
import 'package:hafiz/features/auth/presentation/views/forgot_password_view.dart';
import 'package:hafiz/features/auth/presentation/views/sign_up_view.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/features/auth/domain/entities/user.dart' show Role;
import 'package:hafiz/features/hifz/presentation/views/hifz_assignment_list_view.dart';
import 'package:hafiz/features/hifz/presentation/views/hifz_assignment_form_view.dart';
import 'package:hafiz/features/notifications/presentation/views/notification_view.dart';
import 'package:hafiz/features/settings/presentation/views/settings_view.dart';
import 'package:hafiz/features/students/presentation/views/student_list_view.dart';
import 'package:hafiz/features/students/presentation/views/student_profile_view.dart';
import 'package:hafiz/features/students/presentation/views/add_student_view.dart';
import 'package:hafiz/features/students/presentation/views/edit_student_view.dart';
import 'package:hafiz/features/teachers/presentation/views/teacher_list_view.dart';
import 'package:hafiz/features/teachers/presentation/views/teacher_profile_view.dart';
import 'package:hafiz/features/teachers/presentation/views/add_teacher_view.dart';
import 'package:hafiz/features/classes/presentation/views/class_list_view.dart';
import 'package:hafiz/features/classes/presentation/views/class_detail_view.dart';
import 'package:hafiz/features/classes/presentation/views/add_class_view.dart';
import 'package:hafiz/features/attendance/presentation/views/attendance_marking_view.dart';
import 'package:hafiz/features/tasmi/presentation/views/tasmi_eval_view.dart';
import 'package:hafiz/features/schedule/presentation/views/calendar_view.dart';
import 'package:hafiz/features/schedule/presentation/views/session_management_view.dart';
import 'package:hafiz/features/quran/presentation/views/quran_browse_view.dart';
import 'package:hafiz/features/quran/presentation/views/memorization_plan_view.dart';
import 'package:hafiz/features/quran/presentation/views/create_memorization_plan_view.dart';
import 'package:hafiz/features/revision/presentation/views/revision_tracking_view.dart';
import 'package:hafiz/features/assessments/presentation/views/assessment_list_view.dart';
import 'package:hafiz/features/assessments/presentation/views/create_assessment_view.dart';
import 'package:hafiz/features/guardians/presentation/views/guardian_list_view.dart';
import 'package:hafiz/features/guardians/presentation/views/guardian_profile_view.dart';
import 'package:hafiz/features/reports/presentation/views/reports_view.dart';
import 'package:hafiz/features/parent_portal/presentation/views/parent_portal_view.dart';
import 'package:hafiz/features/dashboard/presentation/views/owner_dashboard_view.dart';
import 'package:hafiz/core/theme/theme.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final authStream = ref.watch(authRepositoryProvider).authStateChanges;
  final activeRole = ref.watch(activeRoleProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/forgot-password' ||
          state.matchedLocation == '/sign-up';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) {
        // Route based on role — if no role yet, send to dashboard (will show empty state)
        return switch (activeRole) {
          null => '/dashboard',
          Role.teacher || Role.assistant => '/calendar',
          Role.parent => '/parent-portal',
          _ => '/dashboard',
        };
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authStream),
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpView(),
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
            builder: (context, state) => const OwnerDashboardView(),
          ),
          GoRoute(
            path: '/students',
            builder: (context, state) => const StudentListView(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddStudentView(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => StudentProfileView(
                  studentId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => EditStudentView(
                      studentId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/teachers',
            builder: (context, state) => const TeacherListView(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddTeacherView(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => TeacherProfileView(
                  teacherId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/classes',
            builder: (context, state) => const ClassListView(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddClassView(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => ClassDetailView(
                  classId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/attendance',
            builder: (context, state) => const AttendanceMarkingView(
              sessionId: '',
              classId: '',
            ),
          ),
          GoRoute(
            path: '/tasmi',
            builder: (context, state) => const TasmiEvalView(
              studentId: '',
              teacherId: '',
              sessionId: '',
            ),
          ),
          GoRoute(
            path: '/schedule',
            builder: (context, state) => const CalendarView(),
            routes: [
              GoRoute(
                path: 'sessions',
                builder: (context, state) => const SessionManagementView(),
              ),
            ],
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
            path: '/quran',
            builder: (context, state) => const QuranBrowseView(),
            routes: [
              GoRoute(
                path: 'plans',
                builder: (context, state) => const MemorizationPlanView(),
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => const CreateMemorizationPlanView(),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/revision/:studentId',
            builder: (context, state) => RevisionTrackingView(
              studentId: state.pathParameters['studentId']!,
            ),
          ),
          GoRoute(
            path: '/guardians',
            builder: (context, state) => const GuardianListView(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => GuardianProfileView(
                  guardianId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/assessments',
            builder: (context, state) => const AssessmentListView(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreateAssessmentView(),
              ),
            ],
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsView(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationView(),
          ),
          GoRoute(
            path: '/parent-portal',
            builder: (context, state) => const ParentPortalView(),
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

class _AdminShell extends StatelessWidget {
  const _AdminShell({required this.child});
  final Widget child;

  static const _navItems = [
    _NavItem('لوحة التحكم', '/dashboard', Icons.dashboard),
    _NavItem('الطلاب', '/students', Icons.people),
    _NavItem('المعلمون', '/teachers', Icons.person),
    _NavItem('الفصول', '/classes', Icons.class_),
    _NavItem('الحضور', '/attendance', Icons.check_circle),
    _NavItem('التسميع', '/tasmi', Icons.mic),
    _NavItem('الجدول', '/schedule', Icons.calendar_today),
    _NavItem('الحفظ', '/hifz/assignments', Icons.book),
    _NavItem('القرآن', '/quran', Icons.menu_book),
    _NavItem('الأولياء', '/guardians', Icons.family_restroom),
    _NavItem('التقييمات', '/assessments', Icons.assessment),
    _NavItem('التقارير', '/reports', Icons.summarize),
    _NavItem('الإشعارات', '/notifications', Icons.notifications),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 768;

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: Text('حفيظ', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary)),
          backgroundColor: AppColors.surface,
        ),
        drawer: Drawer(
          child: SafeArea(
            child: _buildSidebarContent(context, isMobile: true),
          ),
        ),
        body: child,
      );
    }

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 248,
            child: _buildSidebarContent(context),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildSidebarContent(BuildContext context, {bool isMobile = false}) {
    return Material(
      color: AppColors.surface,
      child: Column(
        children: [
          if (!isMobile) const SizedBox(height: 48),
          Padding(
            padding: EdgeInsets.all(AppSpacing.m),
            child: Text('حفيظ', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (final item in _navItems)
                  _navItem(context, item.title, item.path, item.icon, isMobile: isMobile),
              ],
            ),
          ),
          _navItem(context, 'الإعدادات', '/settings', Icons.settings, isMobile: isMobile),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, String path, IconData icon, {bool isMobile = false}) {
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
      onTap: () {
        context.go(path);
        if (isMobile) Navigator.pop(context);
      },
    );
  }
}

class _NavItem {
  final String title;
  final String path;
  final IconData icon;
  const _NavItem(this.title, this.path, this.icon);
}
