import 'package:smart_book_access/features/history/data/models/history_api_model.dart';
import 'package:smart_book_access/features/history/data/models/history_hive_model.dart';

abstract interface class IHistoryLocalDataSource {
  Future<bool> cacheHistory(List<HistoryHiveModel> models);
  Future<List<HistoryHiveModel>> getCachedHistory();
  Future<bool> clearHistoryCache();
}

abstract interface class IHistoryRemoteDataSource {
  Future<List<HistoryApiModel>> getMyHistory(int page, int size);
}