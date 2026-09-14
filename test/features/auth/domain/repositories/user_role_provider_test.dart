import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hafiz/features/auth/domain/entities/user.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_repository.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late MockAuthRepository mockAuthRepo;
  late AppUser testUser;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    testUser = createTestUser();
  });

  tearDown(() {
    reset(mockAuthRepo);
  });

  group('userRolesProvider', () {
    test('returns empty list when user is not authenticated', () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
          currentUserProvider.overrideWithValue(null),
        ],
      );

      addTearDown(container.dispose);

      final result = await container.read(userRolesProvider.future);

      expect(result, isEmpty);
    });

    test('returns user roles when user is authenticated', () async {
      final roles = [
        createTestUserRole(role: Role.owner),
        createTestUserRole(id: 'role-2', role: Role.teacher),
      ];

      when(() => mockAuthRepo.getUserRolesForUser(userId: testUser.id))
          .thenAnswer((_) async => roles);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
          currentUserProvider.overrideWithValue(testUser),
        ],
      );

      addTearDown(container.dispose);

      final result = await container.read(userRolesProvider.future);

      expect(result, hasLength(2));
      expect(result[0].role, Role.owner);
      expect(result[1].role, Role.teacher);
      verify(() => mockAuthRepo.getUserRolesForUser(userId: testUser.id))
          .called(1);
    });

    test('throws when repository fails', () async {
      when(() => mockAuthRepo.getUserRolesForUser(userId: testUser.id))
          .thenThrow(Exception('Database error'));

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
          currentUserProvider.overrideWithValue(testUser),
        ],
      );

      addTearDown(container.dispose);

      expect(
        () => container.read(userRolesProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('activeOrganizationIdProvider', () {
    test('returns null when no user roles', () async {
      when(() => mockAuthRepo.getUserRolesForUser(userId: testUser.id))
          .thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
          currentUserProvider.overrideWithValue(testUser),
        ],
      );

      addTearDown(container.dispose);

      // Read to trigger the provider
      await container.read(userRolesProvider.future);

      final result = container.read(activeOrganizationIdProvider);

      expect(result, isNull);
    });

    test('returns first organization ID when roles exist', () async {
      final roles = [
        createTestUserRole(organizationId: 'org-abc'),
      ];

      when(() => mockAuthRepo.getUserRolesForUser(userId: testUser.id))
          .thenAnswer((_) async => roles);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
          currentUserProvider.overrideWithValue(testUser),
        ],
      );

      addTearDown(container.dispose);

      await container.read(userRolesProvider.future);

      final result = container.read(activeOrganizationIdProvider);

      expect(result, 'org-abc');
    });
  });

  group('activeBranchIdProvider', () {
    test('returns first branch ID when roles exist', () async {
      final roles = [
        createTestUserRole(branchId: 'branch-xyz'),
      ];

      when(() => mockAuthRepo.getUserRolesForUser(userId: testUser.id))
          .thenAnswer((_) async => roles);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
          currentUserProvider.overrideWithValue(testUser),
        ],
      );

      addTearDown(container.dispose);

      await container.read(userRolesProvider.future);

      final result = container.read(activeBranchIdProvider);

      expect(result, 'branch-xyz');
    });

    test('returns null when user has no branch', () async {
      final roles = [
        createTestUserRole(branchId: null),
      ];

      when(() => mockAuthRepo.getUserRolesForUser(userId: testUser.id))
          .thenAnswer((_) async => roles);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
          currentUserProvider.overrideWithValue(testUser),
        ],
      );

      addTearDown(container.dispose);

      await container.read(userRolesProvider.future);

      final result = container.read(activeBranchIdProvider);

      expect(result, isNull);
    });
  });

  group('activeRoleProvider', () {
    test('returns user role when roles exist', () async {
      final roles = [
        createTestUserRole(role: Role.teacher),
      ];

      when(() => mockAuthRepo.getUserRolesForUser(userId: testUser.id))
          .thenAnswer((_) async => roles);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
          currentUserProvider.overrideWithValue(testUser),
        ],
      );

      addTearDown(container.dispose);

      await container.read(userRolesProvider.future);

      final result = container.read(activeRoleProvider);

      expect(result, Role.teacher);
    });

    test('returns null when no roles', () async {
      when(() => mockAuthRepo.getUserRolesForUser(userId: testUser.id))
          .thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
          currentUserProvider.overrideWithValue(testUser),
        ],
      );

      addTearDown(container.dispose);

      await container.read(userRolesProvider.future);

      final result = container.read(activeRoleProvider);

      expect(result, isNull);
    });
  });
}
