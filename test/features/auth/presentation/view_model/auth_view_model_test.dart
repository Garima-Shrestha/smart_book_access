import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/services/storage/user_session_service.dart';
import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';
import 'package:smart_book_access/features/auth/domain/usecase/login_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/logout_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/register_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/update_profile_usecase.dart';
import 'package:smart_book_access/features/auth/presentation/state/auth_state.dart';
import 'package:smart_book_access/features/auth/presentation/view_model/auth_view_model.dart';

// Mocks
class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockUserSessionService extends Mock implements UserSessionService {}

class MockFailure extends Failure {
  const MockFailure(super.message);
}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockUpdateProfileUsecase mockUpdateProfileUsecase;
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
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockUpdateProfileUsecase = MockUpdateProfileUsecase();
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
    // Nested group to match sample structure exactly
    group('initial state', () {
      test('should start with initial state on creation', () {
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.initial);
        expect(state.authEntity, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('login', () {
      test(
        'should emit authenticated state when login is successful',
        () async {
          when(
            () => mockLoginUsecase(any()),
          ).thenAnswer((_) async => const Right(tAuthEntity));
          final viewModel = container.read(authViewModelProvider.notifier);

          await viewModel.login(
            email: 'test@example.com',
            password: 'password',
          );

          final state = container.read(authViewModelProvider);
          expect(state.status, AuthStatus.authenticated);
          expect(state.authEntity, tAuthEntity);
          verify(() => mockLoginUsecase(any())).called(1);
        },
      );
    });

    group('register', () {
      test('should emit error state when registration fails', () async {
        const tMessage = 'Registration Failed';
        const tFailure = MockFailure(tMessage);

        when(
          () => mockRegisterUsecase(any()),
        ).thenAnswer((_) async => const Left(tFailure));
        final viewModel = container.read(authViewModelProvider.notifier);

        await viewModel.register(
          username: 'test',
          email: 'test@test.com',
          countryCode: '+977',
          phone: '9841',
          password: 'password',
        );

        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, tMessage);
        verify(() => mockRegisterUsecase(any())).called(1);
      });
    });

    group('logout', () {
      test(
        'should emit unauthenticated state when logout is successful',
        () async {
          when(
            () => mockLogoutUsecase(),
          ).thenAnswer((_) async => const Right(true));
          final viewModel = container.read(authViewModelProvider.notifier);

          await viewModel.logout();

          final state = container.read(authViewModelProvider);
          expect(state.status, AuthStatus.unauthenticated);
          expect(state.authEntity, isNull);
          verify(() => mockLogoutUsecase()).called(1);
        },
      );
    });
  });
}
