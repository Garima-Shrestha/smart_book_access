import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';
import 'package:smart_book_access/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_book_access/features/auth/domain/usecase/login_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockFailure extends Failure {
  const MockFailure(super.message);
}

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUsecase(authRepository: mockRepository);
  });

  const tUser = AuthEntity(
    authId: '1',
    username: 'test',
    email: 'test@test.com',
    countryCode: '+977',
    phone: '9800000000',
  );

  const tParams = LoginUsecaseParams(
    email: 'test@test.com',
    password: 'password',
  );

  group('LoginUsecase', () {
    test('should return Right(AuthEntity) when login is successful', () async {
      // Arrange
      when(
        () => mockRepository.login(any(), any()),
      ).thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(tUser));
      verify(
        () => mockRepository.login(tParams.email, tParams.password),
      ).called(1);
      // BETTER: Proves nothing else happened
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left(Failure) when login fails', () async {
      // Arrange
      const failure = MockFailure('Invalid credentials');
      when(
        () => mockRepository.login(any(), any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
      // Verifies the call even on failure
      verify(() => mockRepository.login(any(), any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
