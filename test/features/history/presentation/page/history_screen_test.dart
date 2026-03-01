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
import 'package:smart_book_access/features/category/domain/usecase/get_all_categories_usecase.dart';
import 'package:smart_book_access/features/category/domain/usecase/get_category_by_id_usecase.dart';
import 'package:smart_book_access/features/category/presentation/state/category_state.dart';
import 'package:smart_book_access/features/category/presentation/view_model/category_view_model.dart';
import 'package:smart_book_access/features/history/domain/entities/history_entity.dart';
import 'package:smart_book_access/features/history/domain/usecase/get_my_history_usecase.dart';
import 'package:smart_book_access/features/history/presentation/page/history_screen.dart';
import 'package:smart_book_access/features/history/presentation/state/history_state.dart';
import 'package:smart_book_access/features/history/presentation/view_model/history_view_model.dart';

class MockGetMyHistoryUsecase extends Mock implements GetMyHistoryUsecase {}

class MockGetAllCategoriesUsecase extends Mock
    implements GetAllCategoriesUsecase {}

class MockGetCategoryByIdUsecase extends Mock
    implements GetCategoryByIdUsecase {}

class MockGetAllBooksUsecase extends Mock implements GetAllBooksUsecase {}

class MockGetBookByIdUsecase extends Mock implements GetBookByIdUsecase {}

class MockGetBooksByCategoryUsecase extends Mock
    implements GetBooksByCategoryUsecase {}

void main() {
  late MockGetMyHistoryUsecase mockGetMyHistoryUsecase;
  late MockGetAllCategoriesUsecase mockGetAllCategoriesUsecase;
  late MockGetCategoryByIdUsecase mockGetCategoryByIdUsecase;
  late MockGetAllBooksUsecase mockGetAllBooksUsecase;
  late MockGetBookByIdUsecase mockGetBookByIdUsecase;
  late MockGetBooksByCategoryUsecase mockGetBooksByCategoryUsecase;

  setUpAll(() {
    registerFallbackValue(const GetMyHistoryUsecaseParams(page: 1, size: 10));
    registerFallbackValue(const GetAllBooksParams(page: 1, size: 10));
  });

  setUp(() {
    mockGetMyHistoryUsecase = MockGetMyHistoryUsecase();
    mockGetAllCategoriesUsecase = MockGetAllCategoriesUsecase();
    mockGetCategoryByIdUsecase = MockGetCategoryByIdUsecase();
    mockGetAllBooksUsecase = MockGetAllBooksUsecase();
    mockGetBookByIdUsecase = MockGetBookByIdUsecase();
    mockGetBooksByCategoryUsecase = MockGetBooksByCategoryUsecase();

    when(
      () => mockGetAllBooksUsecase(any()),
    ).thenAnswer((_) async => const Right([]));
  });

  Widget createTestWidget({HistoryState? historyState}) {
    return ProviderScope(
      overrides: [
        getMyHistoryUsecaseProvider.overrideWithValue(mockGetMyHistoryUsecase),
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
        historyViewModelProvider.overrideWith(
          () => _FakeHistoryViewModel(historyState ?? const HistoryState()),
        ),
        categoryViewModelProvider.overrideWith(() => _FakeCategoryViewModel()),
        bookViewModelProvider.overrideWith(() => _FakeBookViewModel()),
      ],
      child: const MaterialApp(home: HistoryScreen()),
    );
  }

  group('HistoryScreen Widget Tests', () {
    testWidgets('should show empty state when no history', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('No history found'), findsOneWidget);
    });

    testWidgets('should display history items when history is loaded', (
      tester,
    ) async {
      final tHistory = [
        HistoryEntity(
          accessId: 'access_1',
          bookId: 'book_1',
          title: 'Test Book',
          author: 'Test Author',
          pages: 100,
          rentedAt: DateTime(2024, 1, 1),
          expiresAt: DateTime(2024, 1, 8),
          isExpired: false,
          isInactive: false,
          canReRent: false,
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          historyState: HistoryState(
            status: HistoryStatus.loaded,
            historyList: tHistory,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Book'), findsOneWidget);
      expect(find.text('Test Author'), findsOneWidget);
    });
  });
}

class _FakeHistoryViewModel extends HistoryViewModel {
  final HistoryState _initial;
  _FakeHistoryViewModel(this._initial);

  @override
  HistoryState build() => _initial;

  @override
  Future<void> getMyHistory({required int page, required int size}) async {}
}

class _FakeCategoryViewModel extends CategoryViewModel {
  @override
  CategoryState build() => const CategoryState();

  @override
  Future<void> getAllCategories() async {}
}

class _FakeBookViewModel extends BookViewModel {
  @override
  BookState build() => const BookState();

  @override
  Future<void> getAllBooks({String? searchTerm}) async {}
}
