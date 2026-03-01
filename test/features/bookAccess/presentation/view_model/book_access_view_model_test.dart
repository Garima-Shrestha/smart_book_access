import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/add_bookmark_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/add_quote_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/get_book_access_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/remove_bookmark_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/remove_quote_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/update_last_position_usecase.dart';
import 'package:smart_book_access/features/bookAccess/presentation/state/book_access_state.dart';
import 'package:smart_book_access/features/bookAccess/presentation/view_model/book_access_view_model.dart';

class MockGetBookAccessUsecase extends Mock implements GetBookAccessUsecase {}

class MockAddBookmarkUsecase extends Mock implements AddBookmarkUsecase {}

class MockRemoveBookmarkUsecase extends Mock implements RemoveBookmarkUsecase {}

class MockAddQuoteUsecase extends Mock implements AddQuoteUsecase {}

class MockRemoveQuoteUsecase extends Mock implements RemoveQuoteUsecase {}

class MockUpdateLastPositionUsecase extends Mock
    implements UpdateLastPositionUsecase {}

class MockFailure extends Failure {
  const MockFailure(super.message);
}

void main() {
  late MockGetBookAccessUsecase mockGetBookAccessUsecase;
  late MockAddBookmarkUsecase mockAddBookmarkUsecase;
  late MockRemoveBookmarkUsecase mockRemoveBookmarkUsecase;
  late MockAddQuoteUsecase mockAddQuoteUsecase;
  late MockRemoveQuoteUsecase mockRemoveQuoteUsecase;
  late MockUpdateLastPositionUsecase mockUpdateLastPositionUsecase;
  late ProviderContainer container;

  const tBookAccess = BookAccessEntity(
    id: 'access_1',
    bookId: 'book_1',
    pdfUrl: '/uploads/pdfs/test.pdf',
    bookmarks: [],
    quotes: [],
  );

  setUpAll(() {
    registerFallbackValue(
      const BookmarkParams(
        bookId: '',
        bookmark: BookmarkEntity(page: 1, text: ''),
      ),
    );
    registerFallbackValue(const RemoveBookmarkParams(bookId: '', index: 0));
    registerFallbackValue(
      const QuoteParams(
        bookId: '',
        quote: QuoteEntity(page: 1, text: ''),
      ),
    );
    registerFallbackValue(const RemoveQuoteParams(bookId: '', index: 0));
    registerFallbackValue(
      const PositionParams(
        bookId: '',
        position: LastPositionEntity(page: 1, offsetY: 0),
      ),
    );
  });

  setUp(() {
    mockGetBookAccessUsecase = MockGetBookAccessUsecase();
    mockAddBookmarkUsecase = MockAddBookmarkUsecase();
    mockRemoveBookmarkUsecase = MockRemoveBookmarkUsecase();
    mockAddQuoteUsecase = MockAddQuoteUsecase();
    mockRemoveQuoteUsecase = MockRemoveQuoteUsecase();
    mockUpdateLastPositionUsecase = MockUpdateLastPositionUsecase();

    container = ProviderContainer(
      overrides: [
        getBookAccessUsecaseProvider.overrideWithValue(
          mockGetBookAccessUsecase,
        ),
        addBookmarkUsecaseProvider.overrideWithValue(mockAddBookmarkUsecase),
        removeBookmarkUsecaseProvider.overrideWithValue(
          mockRemoveBookmarkUsecase,
        ),
        addQuoteUsecaseProvider.overrideWithValue(mockAddQuoteUsecase),
        removeQuoteUsecaseProvider.overrideWithValue(mockRemoveQuoteUsecase),
        updateLastPositionUsecaseProvider.overrideWithValue(
          mockUpdateLastPositionUsecase,
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('BookAccessViewModel', () {
    test('should emit loaded state when fetchBookAccess succeeds', () async {
      when(
        () => mockGetBookAccessUsecase(any()),
      ).thenAnswer((_) async => const Right(tBookAccess));

      final viewModel = container.read(bookAccessViewModelProvider.notifier);
      await viewModel.fetchBookAccess('book_1');

      final state = container.read(bookAccessViewModelProvider);
      expect(state.status, BookAccessStatus.loaded);
      expect(state.bookAccess, tBookAccess);
      verify(() => mockGetBookAccessUsecase('book_1')).called(1);
    });

    test('should emit error state when fetchBookAccess fails', () async {
      const tFailure = MockFailure('Book access not found');
      when(
        () => mockGetBookAccessUsecase(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final viewModel = container.read(bookAccessViewModelProvider.notifier);
      await viewModel.fetchBookAccess('book_1');

      final state = container.read(bookAccessViewModelProvider);
      expect(state.status, BookAccessStatus.error);
      expect(state.errorMessage, 'Book access not found');
    });
  });
}
