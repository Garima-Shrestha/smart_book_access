import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';
import 'package:smart_book_access/features/book/domain/repositories/book_repository.dart';
import 'package:smart_book_access/features/book/domain/usecase/get_all_books_usecase.dart';

class MockBookRepository extends Mock implements IBookRepository {}

class MockFailure extends Failure {
  const MockFailure() : super('Failed to fetch books');
}

void main() {
  late GetAllBooksUsecase usecase;
  late MockBookRepository mockRepository;

  setUp(() {
    mockRepository = MockBookRepository();
    usecase = GetAllBooksUsecase(bookRepository: mockRepository);
  });

  const tBooks = [
    BookEntity(
      bookId: '1',
      title: 'Book One',
      author: 'Author One',
      description: 'Description One',
      genre: 'Fiction',
      pages: 100,
      price: 9.99,
      publishedDate: '2024-01-01',
      coverImageUrl: '/uploads/book1.jpg',
    ),
    BookEntity(
      bookId: '2',
      title: 'Book Two',
      author: 'Author Two',
      description: 'Description Two',
      genre: 'Non-Fiction',
      pages: 200,
      price: 12.99,
      publishedDate: '2024-02-01',
      coverImageUrl: '/uploads/book2.jpg',
    ),
  ];

  const tParams = GetAllBooksParams(page: 1, size: 10);

  group('GetAllBooksUsecase', () {
    test(
      'should return Right(List<BookEntity>) when fetch is successful',
      () async {
        // Arrange
        when(
          () => mockRepository.getAllBooks(
            page: any(named: 'page'),
            size: any(named: 'size'),
            searchTerm: any(named: 'searchTerm'),
          ),
        ).thenAnswer((_) async => const Right(tBooks));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Right(tBooks));
        verify(
          () => mockRepository.getAllBooks(
            page: tParams.page,
            size: tParams.size,
            searchTerm: tParams.searchTerm,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return Left(Failure) when fetch fails', () async {
      // Arrange
      const tFailure = MockFailure();
      when(
        () => mockRepository.getAllBooks(
          page: any(named: 'page'),
          size: any(named: 'size'),
          searchTerm: any(named: 'searchTerm'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(tFailure));
      verify(
        () => mockRepository.getAllBooks(
          page: any(named: 'page'),
          size: any(named: 'size'),
          searchTerm: any(named: 'searchTerm'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
