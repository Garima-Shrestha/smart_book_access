import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
import 'package:smart_book_access/features/bookAccess/domain/repositories/book_access_repository.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/get_book_access_usecase.dart';

class MockBookAccessRepository extends Mock implements IBookAccessRepository {}

class MockFailure extends Failure {
  const MockFailure() : super('Failed to fetch book access');
}

void main() {
  late GetBookAccessUsecase usecase;
  late MockBookAccessRepository mockRepository;

  setUp(() {
    mockRepository = MockBookAccessRepository();
    usecase = GetBookAccessUsecase(repository: mockRepository);
  });

  const tBookAccess = BookAccessEntity(
    id: 'access_1',
    bookId: 'book_1',
    pdfUrl: '/uploads/pdfs/test.pdf',
    bookmarks: [],
    quotes: [],
  );

  const tBookId = 'book_1';

  group('GetBookAccessUsecase', () {
    test(
      'should return Right(BookAccessEntity) when fetch is successful',
      () async {
        // Arrange
        when(
          () => mockRepository.getBookAccess(any()),
        ).thenAnswer((_) async => const Right(tBookAccess));

        // Act
        final result = await usecase(tBookId);

        // Assert
        expect(result, const Right(tBookAccess));
        verify(() => mockRepository.getBookAccess(tBookId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return Left(Failure) when fetch fails', () async {
      // Arrange
      const tFailure = MockFailure();
      when(
        () => mockRepository.getBookAccess(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(tBookId);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.getBookAccess(tBookId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
