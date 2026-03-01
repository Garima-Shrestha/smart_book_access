import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';
import 'package:smart_book_access/features/book/domain/usecase/get_all_books_usecase.dart';
import 'package:smart_book_access/features/book/domain/usecase/get_book_by_id_usecase.dart';
import 'package:smart_book_access/features/book/domain/usecase/get_books_by_category_usecase.dart';
import 'package:smart_book_access/features/book/presentation/state/book_state.dart';
import 'package:smart_book_access/features/book/presentation/view_model/book_view_model.dart';

class MockGetAllBooksUsecase extends Mock implements GetAllBooksUsecase {}

class MockGetBookByIdUsecase extends Mock implements GetBookByIdUsecase {}

class MockGetBooksByCategoryUsecase extends Mock
    implements GetBooksByCategoryUsecase {}

class MockFailure extends Failure {
  const MockFailure(super.message);
}

void main() {
  late MockGetAllBooksUsecase mockGetAllBooksUsecase;
  late MockGetBookByIdUsecase mockGetBookByIdUsecase;
  late MockGetBooksByCategoryUsecase mockGetBooksByCategoryUsecase;
  late ProviderContainer container;

  const tBook = BookEntity(
    bookId: '1',
    title: 'Book One',
    author: 'Author One',
    description: 'Description One',
    genre: 'Fiction',
    pages: 100,
    price: 9.99,
    publishedDate: '2024-01-01',
    coverImageUrl: '/uploads/book1.jpg',
  );

  const tBooks = [tBook];

  setUpAll(() {
    registerFallbackValue(const GetAllBooksParams(page: 1, size: 10));
  });

  setUp(() {
    mockGetAllBooksUsecase = MockGetAllBooksUsecase();
    mockGetBookByIdUsecase = MockGetBookByIdUsecase();
    mockGetBooksByCategoryUsecase = MockGetBooksByCategoryUsecase();

    when(
      () => mockGetAllBooksUsecase(any()),
    ).thenAnswer((_) async => const Right(tBooks));

    container = ProviderContainer(
      overrides: [
        getAllBooksUsecaseProvider.overrideWithValue(mockGetAllBooksUsecase),
        getBookByIdUsecaseProvider.overrideWithValue(mockGetBookByIdUsecase),
        getBooksByCategoryUsecaseProvider.overrideWithValue(
          mockGetBooksByCategoryUsecase,
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('BookViewModel', () {
    test(
      'should emit success state with books when getAllBooks succeeds',
      () async {
        when(
          () => mockGetAllBooksUsecase(any()),
        ).thenAnswer((_) async => const Right(tBooks));

        final viewModel = container.read(bookViewModelProvider.notifier);
        await viewModel.getAllBooks();

        final state = container.read(bookViewModelProvider);
        expect(state.status, BookStatus.success);
        expect(state.books, tBooks);
      },
    );

    test('should emit error state when getAllBooks fails', () async {
      const tFailure = MockFailure('Failed to fetch books');
      when(
        () => mockGetAllBooksUsecase(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final viewModel = container.read(bookViewModelProvider.notifier);
      await viewModel.getAllBooks();

      final state = container.read(bookViewModelProvider);
      expect(state.status, BookStatus.error);
      expect(state.errorMessage, 'Failed to fetch books');
    });
  });
}
