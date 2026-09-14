import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hafiz/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:hafiz/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:hafiz/features/dashboard/domain/repositories/dashboard_provider.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/features/auth/domain/entities/user.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_repository.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late MockDashboardRepository mockDashboardRepo;
  late MockAuthRepository mockAuthRepo;
  late AppUser testUser;

  setUp(() {
    mockDashboardRepo = MockDashboardRepository();
    mockAuthRepo = MockAuthRepository();
    testUser = createTestUser();
  });

  tearDown(() {
    reset(mockDashboardRepo);
    reset(mockAuthRepo);
  });

  group('dashboardStatsProvider', () {
    test('returns empty stats when no organization ID', () async {
      final container = ProviderContainer(
        overrides: [
          dashboardRepositoryProvider.overrideWithValue(mockDashboardRepo),
          activeOrganizationIdProvider.overrideWithValue(null),
        ],
      );

      addTearDown(container.dispose);

      final result = await container.read(dashboardStatsProvider.future);

      expect(result.totalStudents, 0);
      expect(result.totalTeachers, 0);
      expect(result.totalClasses, 0);
    });

    test('returns stats when organization ID exists', () async {
      final expectedStats = createTestDashboardStats(
        totalStudents: 50,
        totalTeachers: 10,
        totalClasses: 8,
      );

      when(() => mockDashboardRepo.getDashboardStats('org-123'))
          .thenAnswer((_) async => expectedStats);

      final container = ProviderContainer(
        overrides: [
          dashboardRepositoryProvider.overrideWithValue(mockDashboardRepo),
          activeOrganizationIdProvider.overrideWithValue('org-123'),
        ],
      );

      addTearDown(container.dispose);

      final result = await container.read(dashboardStatsProvider.future);

      expect(result.totalStudents, 50);
      expect(result.totalTeachers, 10);
      expect(result.totalClasses, 8);
      verify(() => mockDashboardRepo.getDashboardStats('org-123')).called(1);
    });

    test('returns error when repository throws', () async {
      when(() => mockDashboardRepo.getDashboardStats('org-123'))
          .thenThrow(Exception('Network error'));

      final container = ProviderContainer(
        overrides: [
          dashboardRepositoryProvider.overrideWithValue(mockDashboardRepo),
          activeOrganizationIdProvider.overrideWithValue('org-123'),
        ],
      );

      addTearDown(container.dispose);

      expect(
        () => container.read(dashboardStatsProvider.future),
        throwsA(isA<Exception>()),
      );
    });

    test('returns correct stats for complex data', () async {
      final expectedStats = DashboardStats(
        totalStudents: 120,
        activeStudents: 95,
        totalTeachers: 15,
        totalClasses: 12,
        todaySessions: 8,
        pendingAssignments: 20,
        completedAssignments: 150,
        overdueAssignments: 5,
        unreadNotifications: 3,
      );

      when(() => mockDashboardRepo.getDashboardStats('org-456'))
          .thenAnswer((_) async => expectedStats);

      final container = ProviderContainer(
        overrides: [
          dashboardRepositoryProvider.overrideWithValue(mockDashboardRepo),
          activeOrganizationIdProvider.overrideWithValue('org-456'),
        ],
      );

      addTearDown(container.dispose);

      final result = await container.read(dashboardStatsProvider.future);

      expect(result.totalStudents, 120);
      expect(result.activeStudents, 95);
      expect(result.pendingAssignments, 20);
      expect(result.completedAssignments, 150);
      expect(result.overdueAssignments, 5);
    });
  });
}
