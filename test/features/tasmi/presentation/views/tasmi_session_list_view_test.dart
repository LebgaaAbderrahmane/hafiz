import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hafiz/features/tasmi/domain/entities/tasmi_session.dart';
import 'package:hafiz/features/tasmi/domain/repositories/tasmi_repository.dart';
import 'package:hafiz/features/tasmi/domain/repositories/tasmi_provider.dart';
import 'package:hafiz/features/tasmi/presentation/views/tasmi_session_list_view.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_repository.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/features/auth/domain/entities/user.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late MockTasmiRepository mockTasmiRepo;
  late MockAuthRepository mockAuthRepo;

  setUpAll(() async {
    await initializeDateFormatting('ar');
  });

  setUp(() {
    mockTasmiRepo = MockTasmiRepository();
    mockAuthRepo = MockAuthRepository();
    when(() => mockAuthRepo.currentUser).thenAnswer((_) async => null);
    when(() => mockAuthRepo.authStateChanges)
        .thenAnswer((_) => Stream.value(null));
    when(() => mockAuthRepo.getUserRolesForUser(userId: any(named: 'userId')))
        .thenAnswer((_) async => []);
  });

  tearDown(() {
    reset(mockTasmiRepo);
    reset(mockAuthRepo);
  });

  Widget buildTasmiSessionListView({
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
        currentUserProvider.overrideWithValue(null),
        userRolesProvider.overrideWith((ref) async => []),
        ...overrides,
      ],
      child: MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: const TasmiSessionListView(),
        ),
      ),
    );
  }

  group('TasmiSessionListView', () {
    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(buildTasmiSessionListView(
        overrides: [
          branchTasmiSessionsProvider.overrideWith((ref) async => []),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('جلسات التسميع'), findsOneWidget);
    });

    testWidgets('renders add session button in app bar', (tester) async {
      await tester.pumpWidget(buildTasmiSessionListView(
        overrides: [
          branchTasmiSessionsProvider.overrideWith((ref) async => []),
        ],
      ));
      await tester.pumpAndSettle();

      // AppBar IconButton with Icons.add exists alongside EmptyState's add icon
      final addIcons = find.byIcon(Icons.add);
      expect(addIcons, findsAtLeastNWidgets(1));
    });

    testWidgets('shows empty state when no sessions', (tester) async {
      await tester.pumpWidget(buildTasmiSessionListView(
        overrides: [
          branchTasmiSessionsProvider.overrideWith((ref) async => []),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('لا توجد جلسات'), findsOneWidget);
      expect(find.text('لا توجد جلسات تسميع لهذا الفرع'), findsOneWidget);
      expect(find.text('إضافة جلسة'), findsOneWidget);
    });

    testWidgets('shows loading indicator while loading', (tester) async {
      final completer = Completer<List<TasmiSession>>();

      await tester.pumpWidget(buildTasmiSessionListView(
        overrides: [
          branchTasmiSessionsProvider
              .overrideWith((ref) => completer.future),
        ],
      ));
      await tester.pump();

      // Should show some loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error state when error occurs', (tester) async {
      await tester.pumpWidget(buildTasmiSessionListView(
        overrides: [
          branchTasmiSessionsProvider.overrideWith(
            (ref) async => throw Exception('Network error'),
          ),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Network error'), findsOneWidget);
    });

    testWidgets('renders filter chips', (tester) async {
      await tester.pumpWidget(buildTasmiSessionListView(
        overrides: [
          branchTasmiSessionsProvider.overrideWith((ref) async => []),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('الكل'), findsOneWidget);
      expect(find.text('اليوم'), findsOneWidget);
      expect(find.text('هذا الأسبوع'), findsOneWidget);
    });

    testWidgets('renders session list when sessions exist', (tester) async {
      final sessions = [
        createTestTasmiSession(
          id: 'session-1',
          studentId: 'student-12345678',
        ),
        createTestTasmiSession(
          id: 'session-2',
          studentId: 'student-87654321',
          outcome: TasmiOutcome.needsRevision,
        ),
      ];

      await tester.pumpWidget(buildTasmiSessionListView(
        overrides: [
          branchTasmiSessionsProvider
              .overrideWith((ref) async => sessions),
        ],
      ));
      await tester.pumpAndSettle();

      // Should show session cards (studentId.substring(0,8) = 'student-')
      expect(find.textContaining('طالب: student-'), findsNWidgets(2));

      // Should show outcomes
      expect(find.text('نجح'), findsOneWidget);
      expect(find.text('يحتاج مراجعة'), findsOneWidget);
    });

    testWidgets('renders surah names in session cards', (tester) async {
      final sessions = [
        createTestTasmiSession(
          id: 'session-1',
          startSurah: 1,
          startAyah: 1,
          endSurah: 1,
          endAyah: 7,
        ),
      ];

      await tester.pumpWidget(buildTasmiSessionListView(
        overrides: [
          branchTasmiSessionsProvider
              .overrideWith((ref) async => sessions),
        ],
      ));
      await tester.pumpAndSettle();

      // Should show Al-Fatiha (surah 1)
      expect(find.textContaining('الفاتحة'), findsOneWidget);
    });
  });
}
