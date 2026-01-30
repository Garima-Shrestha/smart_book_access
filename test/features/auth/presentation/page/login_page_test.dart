import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/features/auth/domain/usecase/login_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/logout_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/register_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/update_profile_usecase.dart';
import 'package:smart_book_access/features/auth/presentation/page/login_page.dart';
import 'package:smart_book_access/core/services/storage/user_session_service.dart';
import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';
import 'package:smart_book_access/core/widgets/my_button.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockUpdateProfileUsecase mockUpdateProfileUsecase;
  late MockUserSessionService mockSessionService;

  setUpAll(() {
    registerFallbackValue(
      const LoginUsecaseParams(
        email: 'fallback@email.com',
        password: 'fallback',
      ),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockUpdateProfileUsecase = MockUpdateProfileUsecase();
    mockSessionService = MockUserSessionService();

    when(() => mockSessionService.isLoggedIn()).thenReturn(false);
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
        updateProfileUsecaseProvider.overrideWithValue(
          mockUpdateProfileUsecase,
        ),
        userSessionServiceProvider.overrideWithValue(mockSessionService),
      ],
      child: const MaterialApp(home: LoginPage()),
    );
  }

  group('LoginPage Form Validation', () {
    testWidgets('should show validation errors when fields are empty', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final loginButton = find.byType(MyButton);
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pump();

      // Verify specific
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });
  });

  group('LoginPage Form Submission', () {
    testWidgets('should call login usecase when form is valid', (tester) async {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      await binding.setSurfaceSize(const Size(800, 1200));

      await tester.runAsync(() async {
        // Arrange
        final authEntity = AuthEntity(
          authId: '1',
          username: 'testuser',
          email: 'test@gmail.com',
          phone: '9841000000',
          countryCode: '+977',
        );

        when(
          () => mockLoginUsecase.call(any()),
        ).thenAnswer((_) async => Right(authEntity));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          'test@gmail.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          'password123',
        );
        await tester.pump();

        final loginButton = find.byType(MyButton);
        await tester.ensureVisible(loginButton);
        await tester.tap(loginButton);

        await Future.delayed(const Duration(milliseconds: 2500));
        await tester.pump();

        // Assert
        verify(() => mockLoginUsecase.call(any())).called(1);
      });

      await binding.setSurfaceSize(null);
    });
  });
}
