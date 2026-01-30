import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';
import 'package:smart_book_access/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_book_access/features/auth/domain/usecase/register_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockFailure extends Failure {
  const MockFailure() : super('Registration failed');
}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const AuthEntity(
        username: '',
        email: '',
        countryCode: '',
        phone: '',
        password: '',
      ),
    );
  });

  final tParams = RegisterUsecaseParams(
    username: 'testuser',
    email: 'test@example.com',
    countryCode: '+977',
    phone: '9800000000',
    password: 'password123',
  );

  group('RegisterUsecase', () {
    test(
      'should return a successful result when registration succeeds',
      () async {
        // Arrange
        when(
          () => mockRepository.register(any()),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Right(true));
        verify(() => mockRepository.register(any())).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return a failure result when registration fails', () async {
      // Arrange
      const tFailure = MockFailure();
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.register(any())).called(1);
    });

    test(
      'should send AuthEntity with correct values to the repository',
      () async {
        // Arrange
        AuthEntity? capturedEntity;
        when(() => mockRepository.register(any())).thenAnswer((invocation) {
          capturedEntity = invocation.positionalArguments[0] as AuthEntity;
          return Future.value(const Right(true));
        });

        // Act
        await usecase(tParams);

        // Assert
        expect(capturedEntity?.username, tParams.username);
        expect(capturedEntity?.email, tParams.email);
        expect(capturedEntity?.phone, tParams.phone);
      },
    );
  });
}
