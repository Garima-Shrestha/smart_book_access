import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/category/data/repositories/category_repository.dart';
import 'package:smart_book_access/features/category/domain/entities/category_entity.dart';
import 'package:smart_book_access/features/category/domain/repositories/category_repository.dart';

final getCategoryByIdUsecaseProvider = Provider<GetCategoryByIdUsecase>((ref) {
  return GetCategoryByIdUsecase(
    categoryRepository: ref.read(categoryRepositoryProvider),
  );
});

class GetCategoryByIdUsecase implements UsecaseWithParams<CategoryEntity, String> {
  final ICategoryRepository _categoryRepository;

  GetCategoryByIdUsecase({required ICategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, CategoryEntity>> call(String params) {
    return _categoryRepository.getCategoryById(params);
  }
}