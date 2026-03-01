import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/category/domain/entities/category_entity.dart';
import 'package:smart_book_access/features/category/domain/usecase/get_all_categories_usecase.dart';
import 'package:smart_book_access/features/category/domain/usecase/get_category_by_id_usecase.dart';
import 'package:smart_book_access/features/category/presentation/state/category_state.dart';
import 'package:smart_book_access/features/category/presentation/view_model/category_view_model.dart';

class MockGetAllCategoriesUsecase extends Mock
    implements GetAllCategoriesUsecase {}

class MockGetCategoryByIdUsecase extends Mock
    implements GetCategoryByIdUsecase {}

class MockFailure extends Failure {
  const MockFailure(super.message);
}

void main() {
  late MockGetAllCategoriesUsecase mockGetAllCategoriesUsecase;
  late MockGetCategoryByIdUsecase mockGetCategoryByIdUsecase;
  late ProviderContainer container;

  const tCategories = [
    CategoryEntity(categoryId: '1', categoryName: 'Fiction'),
    CategoryEntity(categoryId: '2', categoryName: 'Non-Fiction'),
  ];

  setUp(() {
    mockGetAllCategoriesUsecase = MockGetAllCategoriesUsecase();
    mockGetCategoryByIdUsecase = MockGetCategoryByIdUsecase();

    when(
      () => mockGetAllCategoriesUsecase(),
    ).thenAnswer((_) async => const Right(tCategories));

    container = ProviderContainer(
      overrides: [
        getAllCategoriesUsecaseProvider.overrideWithValue(
          mockGetAllCategoriesUsecase,
        ),
        getCategoryByIdUsecaseProvider.overrideWithValue(
          mockGetCategoryByIdUsecase,
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('CategoryViewModel', () {
    test(
      'should emit loaded state with categories when getAllCategories succeeds',
      () async {
        when(
          () => mockGetAllCategoriesUsecase(),
        ).thenAnswer((_) async => const Right(tCategories));

        final viewModel = container.read(categoryViewModelProvider.notifier);
        await viewModel.getAllCategories();

        final state = container.read(categoryViewModelProvider);
        expect(state.status, CategoryStatus.loaded);
        expect(state.categories, tCategories);
      },
    );

    test('should emit error state when getAllCategories fails', () async {
      const tFailure = MockFailure('Failed to fetch categories');
      when(
        () => mockGetAllCategoriesUsecase(),
      ).thenAnswer((_) async => const Left(tFailure));

      final viewModel = container.read(categoryViewModelProvider.notifier);
      await viewModel.getAllCategories();

      final state = container.read(categoryViewModelProvider);
      expect(state.status, CategoryStatus.error);
      expect(state.errorMessage, 'Failed to fetch categories');
    });
  });
}
