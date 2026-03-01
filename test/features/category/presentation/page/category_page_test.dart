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
import 'package:smart_book_access/features/category/domain/entities/category_entity.dart';
import 'package:smart_book_access/features/category/domain/usecase/get_all_categories_usecase.dart';
import 'package:smart_book_access/features/category/domain/usecase/get_category_by_id_usecase.dart';
import 'package:smart_book_access/features/category/presentation/page/category_page.dart';
import 'package:smart_book_access/features/category/presentation/state/category_state.dart';
import 'package:smart_book_access/features/category/presentation/view_model/category_view_model.dart';
import 'package:smart_book_access/features/library/domain/usecase/get_my_library_usecase.dart';
import 'package:smart_book_access/features/library/presentation/state/my_library_state.dart';
import 'package:smart_book_access/features/library/presentation/view_model/my_library_view_model.dart';

class MockGetAllCategoriesUsecase extends Mock
    implements GetAllCategoriesUsecase {}

class MockGetCategoryByIdUsecase extends Mock
    implements GetCategoryByIdUsecase {}

class MockGetAllBooksUsecase extends Mock implements GetAllBooksUsecase {}

class MockGetBookByIdUsecase extends Mock implements GetBookByIdUsecase {}

class MockGetBooksByCategoryUsecase extends Mock
    implements GetBooksByCategoryUsecase {}

class MockGetMyLibraryUsecase extends Mock implements GetMyLibraryUsecase {}

void main() {
  late MockGetAllCategoriesUsecase mockGetAllCategoriesUsecase;
  late MockGetCategoryByIdUsecase mockGetCategoryByIdUsecase;
  late MockGetAllBooksUsecase mockGetAllBooksUsecase;
  late MockGetBookByIdUsecase mockGetBookByIdUsecase;
  late MockGetBooksByCategoryUsecase mockGetBooksByCategoryUsecase;
  late MockGetMyLibraryUsecase mockGetMyLibraryUsecase;

  setUpAll(() {
    registerFallbackValue(const GetAllBooksParams(page: 1, size: 10));
    registerFallbackValue(const GetMyLibraryUsecaseParams(page: 1, size: 10));
  });

  setUp(() {
    mockGetAllCategoriesUsecase = MockGetAllCategoriesUsecase();
    mockGetCategoryByIdUsecase = MockGetCategoryByIdUsecase();
    mockGetAllBooksUsecase = MockGetAllBooksUsecase();
    mockGetBookByIdUsecase = MockGetBookByIdUsecase();
    mockGetBooksByCategoryUsecase = MockGetBooksByCategoryUsecase();
    mockGetMyLibraryUsecase = MockGetMyLibraryUsecase();

    when(
      () => mockGetAllBooksUsecase(any()),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => mockGetMyLibraryUsecase(any()),
    ).thenAnswer((_) async => const Right([]));
  });

  Widget createTestWidget({
    CategoryState? categoryState,
    BookState? bookState,
  }) {
    return ProviderScope(
      overrides: [
        getAllCategoriesUsecaseProvider.overrideWithValue(
          mockGetAllCategoriesUsecase,
        ),
        getCategoryByIdUsecaseProvider.overrideWithValue(
          mockGetCategoryByIdUsecase,
        ),
        getAllBooksUsecaseProvider.overrideWithValue(mockGetAllBooksUsecase),
        getBookByIdUsecaseProvider.overrideWithValue(mockGetBookByIdUsecase),
        getBooksByCategoryUsecaseProvider.overrideWithValue(
          mockGetBooksByCategoryUsecase,
        ),
        getMyLibraryUsecaseProvider.overrideWithValue(mockGetMyLibraryUsecase),
        categoryViewModelProvider.overrideWith(
          () => _FakeCategoryViewModel(categoryState ?? const CategoryState()),
        ),
        bookViewModelProvider.overrideWith(
          () => _FakeBookViewModel(bookState ?? const BookState()),
        ),
        myLibraryViewModelProvider.overrideWith(
          () => _FakeMyLibraryViewModel(),
        ),
      ],
      child: const MaterialApp(home: CategoryPage()),
    );
  }

  group('CategoryPage Widget Tests', () {
    testWidgets('should show empty state when no categories', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('No categories found'), findsOneWidget);
    });

    testWidgets('should display category name when categories are loaded', (
      tester,
    ) async {
      const tCategories = [
        CategoryEntity(categoryId: '1', categoryName: 'fiction'),
      ];

      await tester.pumpWidget(
        createTestWidget(
          categoryState: const CategoryState(
            status: CategoryStatus.loaded,
            categories: tCategories,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Fiction'), findsOneWidget);
    });
  });
}

class _FakeCategoryViewModel extends CategoryViewModel {
  final CategoryState _initial;
  _FakeCategoryViewModel(this._initial);

  @override
  CategoryState build() => _initial;

  @override
  Future<void> getAllCategories() async {}
}

class _FakeBookViewModel extends BookViewModel {
  final BookState _initial;
  _FakeBookViewModel(this._initial);

  @override
  BookState build() => _initial;

  @override
  Future<void> getAllBooks({String? searchTerm}) async {}
}

class _FakeMyLibraryViewModel extends MyLibraryViewModel {
  @override
  MyLibraryState build() => const MyLibraryState();

  @override
  Future<void> fetchMyLibrary({int page = 1, int size = 10}) async {}
}
