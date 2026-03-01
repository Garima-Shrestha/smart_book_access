import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/widgets/my_button.dart';
import 'package:smart_book_access/features/auth/domain/usecase/change_password_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/forgot_password_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/login_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/logout_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/register_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/reset_password_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/update_profile_usecase.dart';
import 'package:smart_book_access/features/auth/presentation/page/forgot_password_page.dart';
import 'package:smart_book_access/core/services/storage/user_session_service.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockChangePasswordUsecase extends Mock implements ChangePasswordUsecase {}

class MockForgotPasswordUsecase extends Mock implements ForgotPasswordUsecase {}

class MockResetPasswordUsecase extends Mock implements ResetPasswordUsecase {}

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockUpdateProfileUsecase mockUpdateProfileUsecase;
  late MockChangePasswordUsecase mockChangePasswordUsecase;
  late MockForgotPasswordUsecase mockForgotPasswordUsecase;
  late MockResetPasswordUsecase mockResetPasswordUsecase;
  late MockUserSessionService mockSessionService;

  setUpAll(() {
    registerFallbackValue(const LoginUsecaseParams(email: '', password: ''));
    registerFallbackValue(
      const RegisterUsecaseParams(
        username: '',
        email: '',
        countryCode: '',
        phone: '',
        password: '',
      ),
    );
    registerFallbackValue(
      const UpdateProfileUsecaseParams(
        username: '',
        email: '',
        countryCode: '',
        phone: '',
      ),
    );
    registerFallbackValue(
      const ChangePasswordParams(oldPassword: '', newPassword: ''),
    );
    registerFallbackValue(const ResetPasswordParams(token: '', password: ''));
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockUpdateProfileUsecase = MockUpdateProfileUsecase();
    mockChangePasswordUsecase = MockChangePasswordUsecase();
    mockForgotPasswordUsecase = MockForgotPasswordUsecase();
    mockResetPasswordUsecase = MockResetPasswordUsecase();
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
        changePasswordUsecaseProvider.overrideWithValue(
          mockChangePasswordUsecase,
        ),
        forgotPasswordUsecaseProvider.overrideWithValue(
          mockForgotPasswordUsecase,
        ),
        resetPasswordUsecaseProvider.overrideWithValue(
          mockResetPasswordUsecase,
        ),
        userSessionServiceProvider.overrideWithValue(mockSessionService),
      ],
      child: const MaterialApp(home: ForgotPasswordPage()),
    );
  }

  group('ForgotPasswordPage Widget Tests', () {
    testWidgets('should show validation error when email is empty', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(MyButton));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'invalidemail');
      await tester.tap(find.byType(MyButton));
      await tester.pump();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });
  });
}
