import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';
import 'package:smart_book_access/features/book/domain/usecase/get_all_books_usecase.dart';
import 'package:smart_book_access/features/book/domain/usecase/get_book_by_id_usecase.dart';
import 'package:smart_book_access/features/book/domain/usecase/get_books_by_category_usecase.dart';
import 'package:smart_book_access/features/book/presentation/state/book_state.dart';
import 'package:smart_book_access/features/book/presentation/view_model/book_view_model.dart';
import 'package:smart_book_access/features/category/domain/entities/category_entity.dart';
import 'package:smart_book_access/features/category/domain/usecase/get_all_categories_usecase.dart';
import 'package:smart_book_access/features/category/domain/usecase/get_category_by_id_usecase.dart';
import 'package:smart_book_access/features/category/presentation/state/category_state.dart';
import 'package:smart_book_access/features/category/presentation/view_model/category_view_model.dart';
import 'package:smart_book_access/features/library/domain/usecase/get_my_library_usecase.dart';
import 'package:smart_book_access/features/library/presentation/state/my_library_state.dart';
import 'package:smart_book_access/features/library/presentation/view_model/my_library_view_model.dart';
import 'package:smart_book_access/features/home/presentation/page/home_screen.dart';

class MockGetAllBooksUsecase extends Mock implements GetAllBooksUsecase {}

class MockGetBookByIdUsecase extends Mock implements GetBookByIdUsecase {}

class MockGetBooksByCategoryUsecase extends Mock
    implements GetBooksByCategoryUsecase {}

class MockGetAllCategoriesUsecase extends Mock
    implements GetAllCategoriesUsecase {}

class MockGetCategoryByIdUsecase extends Mock
    implements GetCategoryByIdUsecase {}

class MockGetMyLibraryUsecase extends Mock implements GetMyLibraryUsecase {}

void main() {
  late MockGetAllBooksUsecase mockGetAllBooksUsecase;
  late MockGetBookByIdUsecase mockGetBookByIdUsecase;
  late MockGetBooksByCategoryUsecase mockGetBooksByCategoryUsecase;
  late MockGetAllCategoriesUsecase mockGetAllCategoriesUsecase;
  late MockGetCategoryByIdUsecase mockGetCategoryByIdUsecase;
  late MockGetMyLibraryUsecase mockGetMyLibraryUsecase;

  setUpAll(() {
    registerFallbackValue(const GetAllBooksParams(page: 1, size: 10));
    registerFallbackValue(const GetMyLibraryUsecaseParams(page: 1, size: 10));
  });

  setUp(() {
    mockGetAllBooksUsecase = MockGetAllBooksUsecase();
    mockGetBookByIdUsecase = MockGetBookByIdUsecase();
    mockGetBooksByCategoryUsecase = MockGetBooksByCategoryUsecase();
    mockGetAllCategoriesUsecase = MockGetAllCategoriesUsecase();
    mockGetCategoryByIdUsecase = MockGetCategoryByIdUsecase();
    mockGetMyLibraryUsecase = MockGetMyLibraryUsecase();

    when(
      () => mockGetAllBooksUsecase(any()),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => mockGetMyLibraryUsecase(any()),
    ).thenAnswer((_) async => const Right([]));
  });

  Widget createTestWidget({
    BookState? bookState,
    CategoryState? categoryState,
  }) {
    return ProviderScope(
      overrides: [
        getAllBooksUsecaseProvider.overrideWithValue(mockGetAllBooksUsecase),
        getBookByIdUsecaseProvider.overrideWithValue(mockGetBookByIdUsecase),
        getBooksByCategoryUsecaseProvider.overrideWithValue(
          mockGetBooksByCategoryUsecase,
        ),
        getAllCategoriesUsecaseProvider.overrideWithValue(
          mockGetAllCategoriesUsecase,
        ),
        getCategoryByIdUsecaseProvider.overrideWithValue(
          mockGetCategoryByIdUsecase,
        ),
        getMyLibraryUsecaseProvider.overrideWithValue(mockGetMyLibraryUsecase),
        bookViewModelProvider.overrideWith(
          () => _FakeBookViewModel(bookState ?? const BookState()),
        ),
        categoryViewModelProvider.overrideWith(
          () => _FakeCategoryViewModel(categoryState ?? const CategoryState()),
        ),
        myLibraryViewModelProvider.overrideWith(
          () => _FakeMyLibraryViewModel(),
        ),
      ],
      child: const MaterialApp(home: Scaffold(body: HomeScreen())),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('should display search bar and section headings', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('Reading Now'), findsOneWidget);
      expect(find.text('New Arrivals'), findsOneWidget);
    });

    testWidgets('should display book in New Arrivals when books are loaded', (
      tester,
    ) async {
      const tBooks = [
        BookEntity(
          bookId: 'book_1',
          title: 'Dart Programming',
          author: 'John Doe',
          description: 'Learn Dart',
          genre: 'cat_1',
          pages: 250,
          price: 500,
          publishedDate: '2024-01-01',
          coverImageUrl: '/uploads/dart.jpg',
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          bookState: const BookState(status: BookStatus.success, books: tBooks),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dart Programming'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });
  });
}

class _FakeBookViewModel extends BookViewModel {
  final BookState _initial;
  _FakeBookViewModel(this._initial);

  @override
  BookState build() => _initial;

  @override
  Future<void> getAllBooks({String? searchTerm}) async {}
}

class _FakeCategoryViewModel extends CategoryViewModel {
  final CategoryState _initial;
  _FakeCategoryViewModel(this._initial);

  @override
  CategoryState build() => _initial;

  @override
  Future<void> getAllCategories() async {}
}

class _FakeMyLibraryViewModel extends MyLibraryViewModel {
  @override
  MyLibraryState build() => const MyLibraryState();

  @override
  Future<void> fetchMyLibrary({int page = 1, int size = 10}) async {}
}
