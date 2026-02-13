import 'package:equatable/equatable.dart';
import 'package:smart_book_access/features/category/domain/entities/category_entity.dart';

enum CategoryStatus {
  initial,
  loading,
  loaded,
  singleLoaded,
  error,
}

class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<CategoryEntity> categories;
  final CategoryEntity? category;
  final String? errorMessage;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const [],
    this.category,
    this.errorMessage,
  });

  // copyWith method to update specific fields
  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryEntity>? categories,
    CategoryEntity? category,
    String? errorMessage,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      category: category ?? this.category,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, categories, category, errorMessage];
}