import 'package:smart_book_access/features/library/data/models/my_library_api_model.dart';
import 'package:smart_book_access/features/library/data/models/my_library_hive_model.dart';

abstract interface class IMyLibraryLocalDataSource {
  Future<void> cacheMyLibrary(List<MyLibraryHiveModel> models);
  Future<List<MyLibraryHiveModel>> getCachedMyLibrary();
  Future<void> clearMyLibraryCache();
}

abstract interface class IMyLibraryRemoteDataSource {
  Future<List<MyLibraryApiModel>> getMyLibrary({int page = 1, int size = 10});
}