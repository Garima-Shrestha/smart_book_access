import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';
import 'package:smart_book_access/features/book/presentation/page/book_detail_page.dart';
import 'package:smart_book_access/features/category/domain/entities/category_entity.dart';
import 'package:smart_book_access/features/category/domain/usecase/get_all_categories_usecase.dart';
import 'package:smart_book_access/features/category/domain/usecase/get_category_by_id_usecase.dart';
import 'package:smart_book_access/features/category/presentation/state/category_state.dart';
import 'package:smart_book_access/features/category/presentation/view_model/category_view_model.dart';

class MockGetAllCategoriesUsecase extends Mock
    implements GetAllCategoriesUsecase {}

class MockGetCategoryByIdUsecase extends Mock
    implements GetCategoryByIdUsecase {}

const tBook = BookEntity(
  bookId: 'book_1',
  title: 'Clean Code',
  author: 'Robert C. Martin',
  description: 'A book about writing clean code.',
  genre: 'cat_1',
  pages: 431,
  price: 800,
  publishedDate: '2008-08-01',
  coverImageUrl: '/uploads/clean_code.jpg',
);

void main() {
  late MockGetAllCategoriesUsecase mockGetAllCategoriesUsecase;
  late MockGetCategoryByIdUsecase mockGetCategoryByIdUsecase;

  setUp(() {
    mockGetAllCategoriesUsecase = MockGetAllCategoriesUsecase();
    mockGetCategoryByIdUsecase = MockGetCategoryByIdUsecase();
  });

  Widget createTestWidget({CategoryState? categoryState}) {
    return ProviderScope(
      overrides: [
        getAllCategoriesUsecaseProvider.overrideWithValue(
          mockGetAllCategoriesUsecase,
        ),
        getCategoryByIdUsecaseProvider.overrideWithValue(
          mockGetCategoryByIdUsecase,
        ),
        categoryViewModelProvider.overrideWith(
          () => _FakeCategoryViewModel(categoryState ?? const CategoryState()),
        ),
      ],
      child: const MaterialApp(home: BookDetailsPage(book: tBook)),
    );
  }

  group('BookDetailsPage Widget Tests', () {
    testWidgets('should display book title, author and price', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Clean Code'), findsOneWidget);
      expect(find.text('by Robert C. Martin'), findsOneWidget);
      expect(find.text('Rs. 800'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should display category name when categories are loaded', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));

      await tester.pumpWidget(
        createTestWidget(
          categoryState: const CategoryState(
            status: CategoryStatus.loaded,
            categories: [
              CategoryEntity(categoryId: 'cat_1', categoryName: 'Technology'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Technology'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
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
