import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';
import 'package:smart_book_access/features/auth/domain/usecase/change_password_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/forgot_password_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/login_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/logout_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/register_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/reset_password_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/update_profile_usecase.dart';
import 'package:smart_book_access/features/auth/presentation/state/auth_state.dart';
import 'package:smart_book_access/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:smart_book_access/core/services/storage/user_session_service.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockChangePasswordUsecase extends Mock implements ChangePasswordUsecase {}

class MockForgotPasswordUsecase extends Mock implements ForgotPasswordUsecase {}

class MockResetPasswordUsecase extends Mock implements ResetPasswordUsecase {}

class MockUserSessionService extends Mock implements UserSessionService {}

class MockFailure extends Failure {
  const MockFailure(super.message);
}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockUpdateProfileUsecase mockUpdateProfileUsecase;
  late MockChangePasswordUsecase mockChangePasswordUsecase;
  late MockForgotPasswordUsecase mockForgotPasswordUsecase;
  late MockResetPasswordUsecase mockResetPasswordUsecase;
  late MockUserSessionService mockUserSessionService;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const RegisterUsecaseParams(
        username: '',
        email: '',
        countryCode: '',
        phone: '',
        password: '',
      ),
    );
    registerFallbackValue(const LoginUsecaseParams(email: '', password: ''));
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
    mockUserSessionService = MockUserSessionService();

    when(() => mockUserSessionService.isLoggedIn()).thenReturn(false);

    container = ProviderContainer(
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
        userSessionServiceProvider.overrideWithValue(mockUserSessionService),
      ],
    );
  });

  tearDown(() => container.dispose());

  const tAuthEntity = AuthEntity(
    authId: '1',
    username: 'testuser',
    email: 'test@example.com',
    countryCode: '+977',
    phone: '9800000000',
  );

  group('AuthViewModel', () {
    test('should start with initial state on creation', () {
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.initial);
      expect(state.authEntity, isNull);
      expect(state.errorMessage, isNull);
    });

    test('should emit authenticated state when login is successful', () async {
      when(
        () => mockLoginUsecase(any()),
      ).thenAnswer((_) async => const Right(tAuthEntity));

      final viewModel = container.read(authViewModelProvider.notifier);
      await viewModel.login(email: 'test@example.com', password: 'password');

      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.authEntity, tAuthEntity);
      verify(() => mockLoginUsecase(any())).called(1);
    });
  });
}
