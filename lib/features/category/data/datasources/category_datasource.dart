import 'package:smart_book_access/features/category/data/models/category_api_model.dart';
import 'package:smart_book_access/features/category/data/models/category_hive_model.dart';

abstract interface class ICategoryLocalDataSource {
  Future<List<CategoryHiveModel>> getAllCategories();
  Future<void> addAllCategories(List<CategoryHiveModel> categories);
}

abstract interface class ICategoryRemoteDataSource {
  Future<List<CategoryApiModel>> getAllCategories();
  Future<CategoryApiModel> getCategoryById(String id);
}