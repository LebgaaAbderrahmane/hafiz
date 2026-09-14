import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hafiz/features/auth/domain/entities/user.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_repository.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';
import 'package:hafiz/features/auth/presentation/views/login_view.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    when(() => mockAuthRepo.currentUser).thenAnswer((_) async => null);
    when(() => mockAuthRepo.authStateChanges)
        .thenAnswer((_) => Stream.value(null));
  });

  tearDown(() {
    reset(mockAuthRepo);
  });

  Widget buildLoginView({
    AppUser? currentUser,
    AsyncValue<AppUser?>? authState,
  }) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
        if (currentUser != null)
          currentUserProvider.overrideWithValue(currentUser),
        if (authState != null)
          authNotifierProvider.overrideWith((ref) {
            final notifier = AuthNotifier(mockAuthRepo);
            // Set the state directly for testing
            return notifier;
          }),
      ],
      child: MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: const LoginView(),
        ),
      ),
    );
  }

  group('LoginView', () {
    testWidgets('renders login form with all required fields',
        (tester) async {
      await tester.pumpWidget(buildLoginView());
      await tester.pumpAndSettle();

      // Check title
      expect(find.text('حافظ'), findsOneWidget);
      expect(find.text('Hafiz'), findsOneWidget);
      expect(find.text('Qur\'an School Management'), findsOneWidget);

      // Check email field
      expect(find.text('البريد الإلكتروني'), findsOneWidget);

      // Check password field
      expect(find.text('كلمة المرور'), findsOneWidget);

      // Check login button
      expect(find.text('تسجيل الدخول'), findsOneWidget);

      // Check sign up link
      expect(find.text('ليس لديك حساب؟'), findsOneWidget);
      expect(find.text('إنشاء حساب'), findsOneWidget);
    });

    testWidgets('renders forgot password link', (tester) async {
      await tester.pumpWidget(buildLoginView());
      await tester.pumpAndSettle();

      expect(find.text('نسيت كلمة المرور؟'), findsOneWidget);
    });

    testWidgets('renders email icon', (tester) async {
      await tester.pumpWidget(buildLoginView());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('renders lock icon for password', (tester) async {
      await tester.pumpWidget(buildLoginView());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('renders menu book icon as logo', (tester) async {
      await tester.pumpWidget(buildLoginView());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);
    });

    testWidgets('renders divider between login and sign up', (tester) async {
      await tester.pumpWidget(buildLoginView());
      await tester.pumpAndSettle();

      expect(find.text('أو'), findsOneWidget);
      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('form fields are present and usable', (tester) async {
      await tester.pumpWidget(buildLoginView());
      await tester.pumpAndSettle();

      // Find text fields
      final textFields = find.byType(TextFormField);
      expect(textFields, findsNWidgets(2));
    });
  });
}
