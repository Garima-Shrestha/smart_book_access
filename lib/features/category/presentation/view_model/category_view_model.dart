import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/features/category/domain/usecase/get_all_categories_usecase.dart';
import 'package:smart_book_access/features/category/domain/usecase/get_category_by_id_usecase.dart';
import 'package:smart_book_access/features/category/presentation/state/category_state.dart';

final categoryViewModelProvider = NotifierProvider<CategoryViewModel, CategoryState>(
      () => CategoryViewModel(),
);

class CategoryViewModel extends Notifier<CategoryState> {
  late final GetAllCategoriesUsecase _getAllCategoriesUsecase;
  late final GetCategoryByIdUsecase _getCategoryByIdUsecase;

  @override
  CategoryState build() {
    _getAllCategoriesUsecase = ref.read(getAllCategoriesUsecaseProvider);
    _getCategoryByIdUsecase = ref.read(getCategoryByIdUsecaseProvider);
    Future.microtask(() => getAllCategories());
    return const CategoryState();
  }

  // Fetch all categories
  Future<void> getAllCategories() async {
    state = state.copyWith(status: CategoryStatus.loading);

    final result = await _getAllCategoriesUsecase.call();

    result.fold(
          (failure) {
        state = state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        );
      },
          (categories) {
        state = state.copyWith(
          status: CategoryStatus.loaded,
          categories: categories,
          errorMessage: null,
        );
      },
    );
  }

  // Fetch a single category by ID
  Future<void> getCategoryById(String id) async {
    state = state.copyWith(status: CategoryStatus.loading);

    final result = await _getCategoryByIdUsecase.call(id);

    result.fold(
          (failure) {
        state = state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        );
      },
          (category) {
        state = state.copyWith(
          status: CategoryStatus.singleLoaded,
          category: category,
          errorMessage: null,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}