import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
import 'package:smart_book_access/features/bookAccess/presentation/page/bookmark_quote_page.dart';
import 'package:smart_book_access/features/bookAccess/presentation/state/book_access_state.dart';
import 'package:smart_book_access/features/bookAccess/presentation/view_model/book_access_view_model.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/add_bookmark_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/add_quote_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/get_book_access_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/remove_bookmark_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/remove_quote_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/update_last_position_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBookAccessUsecase extends Mock implements GetBookAccessUsecase {}

class MockAddBookmarkUsecase extends Mock implements AddBookmarkUsecase {}

class MockRemoveBookmarkUsecase extends Mock implements RemoveBookmarkUsecase {}

class MockAddQuoteUsecase extends Mock implements AddQuoteUsecase {}

class MockRemoveQuoteUsecase extends Mock implements RemoveQuoteUsecase {}

class MockUpdateLastPositionUsecase extends Mock
    implements UpdateLastPositionUsecase {}

void main() {
  late MockGetBookAccessUsecase mockGetBookAccessUsecase;
  late MockAddBookmarkUsecase mockAddBookmarkUsecase;
  late MockRemoveBookmarkUsecase mockRemoveBookmarkUsecase;
  late MockAddQuoteUsecase mockAddQuoteUsecase;
  late MockRemoveQuoteUsecase mockRemoveQuoteUsecase;
  late MockUpdateLastPositionUsecase mockUpdateLastPositionUsecase;

  setUp(() {
    mockGetBookAccessUsecase = MockGetBookAccessUsecase();
    mockAddBookmarkUsecase = MockAddBookmarkUsecase();
    mockRemoveBookmarkUsecase = MockRemoveBookmarkUsecase();
    mockAddQuoteUsecase = MockAddQuoteUsecase();
    mockRemoveQuoteUsecase = MockRemoveQuoteUsecase();
    mockUpdateLastPositionUsecase = MockUpdateLastPositionUsecase();
  });

  Widget createTestWidget({BookAccessState? initialState}) {
    return ProviderScope(
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
        bookAccessViewModelProvider.overrideWith(
          () =>
              _FakeBookAccessViewModel(initialState ?? const BookAccessState()),
        ),
      ],
      child: const MaterialApp(
        home: BookmarkQuotePage(bookId: 'book_1', title: 'Test Book'),
      ),
    );
  }

  group('BookmarkQuotePage Widget Tests', () {
    testWidgets('should show empty state when no bookmarks or quotes', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('BOOKMARKS'), findsOneWidget);
      expect(find.text('QUOTES'), findsOneWidget);
      expect(find.text('No data yet'), findsOneWidget);
    });

    testWidgets('should display bookmarks when bookAccess has bookmarks', (
      tester,
    ) async {
      const tBookAccess = BookAccessEntity(
        id: 'access_1',
        bookId: 'book_1',
        bookmarks: [BookmarkEntity(page: 1, text: 'This is a bookmark text')],
        quotes: [],
      );

      await tester.pumpWidget(
        createTestWidget(
          initialState: const BookAccessState(
            status: BookAccessStatus.loaded,
            bookAccess: tBookAccess,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('This is a bookmark text'), findsOneWidget);
    });
  });
}

class _FakeBookAccessViewModel extends BookAccessViewModel {
  final BookAccessState _initial;

  _FakeBookAccessViewModel(this._initial);

  @override
  BookAccessState build() => _initial;
}
