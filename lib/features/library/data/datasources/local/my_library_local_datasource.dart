import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/services/hive/hive_service.dart';
import 'package:smart_book_access/features/library/data/datasources/my_library_datasource.dart';
import 'package:smart_book_access/features/library/data/models/my_library_hive_model.dart';

final myLibraryLocalDataSourceProvider = Provider<MyLibraryLocalDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return MyLibraryLocalDataSource(hiveService: hiveService);
});

class MyLibraryLocalDataSource implements IMyLibraryLocalDataSource {
  final HiveService _hiveService;

  MyLibraryLocalDataSource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> cacheMyLibrary(List<MyLibraryHiveModel> models) async {
    await _hiveService.cacheMyLibrary(models);
  }

  @override
  Future<List<MyLibraryHiveModel>> getCachedMyLibrary() async {
    try {
      return _hiveService.getCachedMyLibrary();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> clearMyLibraryCache() async {
    await _hiveService.clearMyLibraryCache();
  }
}