import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/services/hive/hive_service.dart';
import 'package:smart_book_access/features/history/data/datasources/history_datasource.dart';
import 'package:smart_book_access/features/history/data/models/history_hive_model.dart';

final historyLocalDataSourceProvider = Provider<HistoryLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return HistoryLocalDatasource(hiveService: hiveService);
});

class HistoryLocalDatasource implements IHistoryLocalDataSource {
  final HiveService _hiveService;

  HistoryLocalDatasource({
    required HiveService hiveService,
  }) : _hiveService = hiveService;

  @override
  Future<bool> cacheHistory(List<HistoryHiveModel> models) async {
    try {
      await _hiveService.cacheHistory(models);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<HistoryHiveModel>> getCachedHistory() async {
    try {
      final items = _hiveService.getCachedHistory();
      return Future.value(List<HistoryHiveModel>.from(items));
    } catch (e) {
      return Future.value([]);
    }
  }

  @override
  Future<bool> clearHistoryCache() async {
    try {
      await _hiveService.clearHistoryCache();
      return true;
    } catch (e) {
      return false;
    }
  }
}