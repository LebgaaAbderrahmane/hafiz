import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hafiz/features/tasmi/domain/entities/tasmi_session.dart';
import 'package:hafiz/features/tasmi/domain/repositories/tasmi_repository.dart';
import 'package:hafiz/features/tasmi/domain/repositories/tasmi_provider.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/features/auth/domain/entities/user.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_repository.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late MockTasmiRepository mockTasmiRepo;
  late MockAuthRepository mockAuthRepo;
  late AppUser testUser;

  setUp(() {
    mockTasmiRepo = MockTasmiRepository();
    mockAuthRepo = MockAuthRepository();
    testUser = createTestUser();
    registerFallbackValue(TasmiSession(
      id: '',
      organizationId: '',
      branchId: '',
      studentId: '',
      teacherId: '',
      sessionId: '',
      startSurah: 1,
      startAyah: 1,
      endSurah: 1,
      endAyah: 1,
      sessionType: TasmiSessionType.newMemorization,
      outcome: TasmiOutcome.pass,
      recordedAt: DateTime.now(),
      createdAt: DateTime.now(),
    ));
  });

  tearDown(() {
    reset(mockTasmiRepo);
    reset(mockAuthRepo);
  });

  group('tasmiRepositoryProvider', () {
    test('returns TasmiRepository when overridden', () {
      final container = ProviderContainer(
        overrides: [
          tasmiRepositoryProvider.overrideWithValue(mockTasmiRepo),
        ],
      );

      addTearDown(container.dispose);

      final repo = container.read(tasmiRepositoryProvider);

      expect(repo, isA<TasmiRepository>());
    });
  });

  group('studentTasmiSessionsProvider', () {
    test('returns sessions for a student', () async {
      final sessions = [
        createTestTasmiSession(id: 'session-1'),
        createTestTasmiSession(id: 'session-2'),
      ];

      when(() => mockTasmiRepo.getStudentSessions('student-1'))
          .thenAnswer((_) async => sessions);

      final container = ProviderContainer(
        overrides: [
          tasmiRepositoryProvider.overrideWithValue(mockTasmiRepo),
        ],
      );

      addTearDown(container.dispose);

      final result = await container.read(
        studentTasmiSessionsProvider('student-1').future,
      );

      expect(result, hasLength(2));
      expect(result[0].id, 'session-1');
      expect(result[1].id, 'session-2');
      verify(() => mockTasmiRepo.getStudentSessions('student-1')).called(1);
    });

    test('returns empty list when no sessions', () async {
      when(() => mockTasmiRepo.getStudentSessions('student-1'))
          .thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [
          tasmiRepositoryProvider.overrideWithValue(mockTasmiRepo),
        ],
      );

      addTearDown(container.dispose);

      final result = await container.read(
        studentTasmiSessionsProvider('student-1').future,
      );

      expect(result, isEmpty);
    });

    test('throws when repository fails', () async {
      when(() => mockTasmiRepo.getStudentSessions('student-1'))
          .thenThrow(Exception('Database error'));

      final container = ProviderContainer(
        overrides: [
          tasmiRepositoryProvider.overrideWithValue(mockTasmiRepo),
        ],
      );

      addTearDown(container.dispose);

      expect(
        () => container.read(studentTasmiSessionsProvider('student-1').future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('teacherTasmiSessionsProvider', () {
    test('returns sessions for a teacher', () async {
      final sessions = [
        createTestTasmiSession(id: 'session-t1', teacherId: 'teacher-1'),
      ];

      when(() => mockTasmiRepo.getTeacherSessions('teacher-1'))
          .thenAnswer((_) async => sessions);

      final container = ProviderContainer(
        overrides: [
          tasmiRepositoryProvider.overrideWithValue(mockTasmiRepo),
        ],
      );

      addTearDown(container.dispose);

      final result = await container.read(
        teacherTasmiSessionsProvider('teacher-1').future,
      );

      expect(result, hasLength(1));
      expect(result[0].teacherId, 'teacher-1');
    });
  });

  group('tasmiSessionProvider', () {
    test('returns a single session by ID', () async {
      final session = createTestTasmiSession(id: 'session-xyz');

      when(() => mockTasmiRepo.getSession('session-xyz'))
          .thenAnswer((_) async => session);

      final container = ProviderContainer(
        overrides: [
          tasmiRepositoryProvider.overrideWithValue(mockTasmiRepo),
        ],
      );

      addTearDown(container.dispose);

      final result = await container.read(
        tasmiSessionProvider('session-xyz').future,
      );

      expect(result, isNotNull);
      expect(result!.id, 'session-xyz');
    });

    test('returns null when session not found', () async {
      when(() => mockTasmiRepo.getSession('non-existent'))
          .thenAnswer((_) async => null);

      final container = ProviderContainer(
        overrides: [
          tasmiRepositoryProvider.overrideWithValue(mockTasmiRepo),
        ],
      );

      addTearDown(container.dispose);

      final result = await container.read(
        tasmiSessionProvider('non-existent').future,
      );

      expect(result, isNull);
    });
  });
}
