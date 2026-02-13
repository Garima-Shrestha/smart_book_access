import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/services/hive/hive_service.dart';
import 'package:smart_book_access/features/category/data/datasources/category_datasource.dart';
import 'package:smart_book_access/features/category/data/models/category_hive_model.dart';

final categoryLocalDataSourceProvider = Provider<CategoryLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return CategoryLocalDatasource(hiveService: hiveService);
});

class CategoryLocalDatasource implements ICategoryLocalDataSource {
  final HiveService _hiveService;

  CategoryLocalDatasource({
    required HiveService hiveService,
  }) : _hiveService = hiveService;

  @override
  Future<List<CategoryHiveModel>> getAllCategories() async {
    try {
      final categories = _hiveService.getAllCategories();
      return Future.value(categories);
    } catch (e) {
      // Return empty list if something goes wrong
      return Future.value([]);
    }
  }

  @override
  Future<void> addAllCategories(List<CategoryHiveModel> categories) async {
    try {
      await _hiveService.addAllCategories(categories);
    } catch (e) {
      // Handle error silently or log it
      print("Hive AddAllCategories Error: $e");
    }
  }
}