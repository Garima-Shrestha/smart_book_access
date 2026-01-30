import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';
import 'package:smart_book_access/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_book_access/features/auth/domain/usecase/update_profile_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockFile extends Mock implements File {}

class MockFailure extends Failure {
  const MockFailure() : super('Update Failed');
}

void main() {
  late UpdateProfileUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = UpdateProfileUsecase(authRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const AuthEntity(username: '', email: '', countryCode: '', phone: ''),
    );
    registerFallbackValue(MockFile());
  });

  final tFile = MockFile();
  final tParams = UpdateProfileUsecaseParams(
    username: 'new_username',
    email: 'test@example.com',
    countryCode: '+977',
    phone: '9800000000',
    imageUrl: tFile,
  );

  group('UpdateProfileUsecase', () {
    test(
      'should return Right(true) when update completes successfully',
      () async {
        // Arrange
        when(
          () => mockRepository.updateProfile(
            any(),
            imageUrl: any(named: 'imageUrl'),
          ),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Right(true));
        verify(
          () => mockRepository.updateProfile(any(), imageUrl: tFile),
        ).called(1);
      },
    );

    test('should return Left(Failure) when update operation fails', () async {
      // Arrange
      const tFailure = MockFailure();
      when(
        () => mockRepository.updateProfile(
          any(),
          imageUrl: any(named: 'imageUrl'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(tFailure));
      verify(
        () => mockRepository.updateProfile(
          any(),
          imageUrl: any(named: 'imageUrl'),
        ),
      ).called(1);
    });

    test('should work correctly when imageUrl is null', () async {
      // Arrange
      final tParamsNoImage = UpdateProfileUsecaseParams(
        username: 'no_image_user',
        email: 'test@example.com',
        countryCode: '+977',
        phone: '9800000000',
        imageUrl: null,
      );

      when(
        () => mockRepository.updateProfile(any(), imageUrl: null),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tParamsNoImage);

      // Assert
      expect(result, const Right(true));
      verify(
        () => mockRepository.updateProfile(any(), imageUrl: null),
      ).called(1);
    });

    test(
      'should create AuthEntity with correct values inside the usecase',
      () async {
        // Arrange
        AuthEntity? capturedEntity;
        when(
          () => mockRepository.updateProfile(
            any(),
            imageUrl: any(named: 'imageUrl'),
          ),
        ).thenAnswer((invocation) {
          capturedEntity = invocation.positionalArguments[0] as AuthEntity;
          return Future.value(const Right(true));
        });

        // Act
        await usecase(tParams);

        // Assert
        // Verifying that params are mapped correctly to the entity fields
        expect(capturedEntity?.username, tParams.username);
        expect(capturedEntity?.email, tParams.email);
        expect(capturedEntity?.countryCode, tParams.countryCode);
        expect(capturedEntity?.phone, tParams.phone);
      },
    );
  });
}
