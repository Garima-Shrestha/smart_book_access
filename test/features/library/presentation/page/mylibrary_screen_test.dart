import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/features/book/domain/usecase/get_all_books_usecase.dart';
import 'package:smart_book_access/features/book/domain/usecase/get_book_by_id_usecase.dart';
import 'package:smart_book_access/features/book/domain/usecase/get_books_by_category_usecase.dart';
import 'package:smart_book_access/features/book/presentation/state/book_state.dart';
import 'package:smart_book_access/features/book/presentation/view_model/book_view_model.dart';
import 'package:smart_book_access/features/library/domain/entities/my_library_entity.dart';
import 'package:smart_book_access/features/library/domain/usecase/get_my_library_usecase.dart';
import 'package:smart_book_access/features/library/presentation/page/mylibrary_screen.dart';
import 'package:smart_book_access/features/library/presentation/state/my_library_state.dart';
import 'package:smart_book_access/features/library/presentation/view_model/my_library_view_model.dart';

class MockGetMyLibraryUsecase extends Mock implements GetMyLibraryUsecase {}

class MockGetAllBooksUsecase extends Mock implements GetAllBooksUsecase {}

class MockGetBookByIdUsecase extends Mock implements GetBookByIdUsecase {}

class MockGetBooksByCategoryUsecase extends Mock
    implements GetBooksByCategoryUsecase {}

void main() {
  late MockGetMyLibraryUsecase mockGetMyLibraryUsecase;
  late MockGetAllBooksUsecase mockGetAllBooksUsecase;
  late MockGetBookByIdUsecase mockGetBookByIdUsecase;
  late MockGetBooksByCategoryUsecase mockGetBooksByCategoryUsecase;

  setUpAll(() {
    registerFallbackValue(const GetMyLibraryUsecaseParams(page: 1, size: 10));
    registerFallbackValue(const GetAllBooksParams(page: 1, size: 10));
  });

  setUp(() {
    mockGetMyLibraryUsecase = MockGetMyLibraryUsecase();
    mockGetAllBooksUsecase = MockGetAllBooksUsecase();
    mockGetBookByIdUsecase = MockGetBookByIdUsecase();
    mockGetBooksByCategoryUsecase = MockGetBooksByCategoryUsecase();

    when(
      () => mockGetAllBooksUsecase(any()),
    ).thenAnswer((_) async => const Right([]));
  });

  Widget createTestWidget({MyLibraryState? libraryState}) {
    return ProviderScope(
      overrides: [
        getMyLibraryUsecaseProvider.overrideWithValue(mockGetMyLibraryUsecase),
        getAllBooksUsecaseProvider.overrideWithValue(mockGetAllBooksUsecase),
        getBookByIdUsecaseProvider.overrideWithValue(mockGetBookByIdUsecase),
        getBooksByCategoryUsecaseProvider.overrideWithValue(
          mockGetBooksByCategoryUsecase,
        ),
        myLibraryViewModelProvider.overrideWith(
          () => _FakeMyLibraryViewModel(libraryState ?? const MyLibraryState()),
        ),
        bookViewModelProvider.overrideWith(() => _FakeBookViewModel()),
      ],
      child: const MaterialApp(home: MylibraryScreen()),
    );
  }

  group('MyLibraryScreen Widget Tests', () {
    testWidgets('should show empty list when library has no books', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('My Library'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display book title and author when library is loaded', (
      tester,
    ) async {
      const tBooks = [
        MyLibraryEntity(
          accessId: 'access_1',
          bookId: 'book_1',
          title: 'Flutter in Action',
          author: 'Eric Windmill',
          pages: 300,
          progressPercent: 40,
          timeLeftLabel: '3 days left',
          isExpired: false,
          isInactive: false,
          canReRent: false,
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          libraryState: const MyLibraryState(
            status: MyLibraryStatus.loaded,
            books: tBooks,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Flutter in Action'), findsOneWidget);
      expect(find.text('Eric Windmill'), findsOneWidget);
    });
  });
}

class _FakeMyLibraryViewModel extends MyLibraryViewModel {
  final MyLibraryState _initial;
  _FakeMyLibraryViewModel(this._initial);

  @override
  MyLibraryState build() => _initial;

  @override
  Future<void> fetchMyLibrary({int page = 1, int size = 10}) async {}
}

class _FakeBookViewModel extends BookViewModel {
  @override
  BookState build() => const BookState();

  @override
  Future<void> getAllBooks({String? searchTerm}) async {}
}
