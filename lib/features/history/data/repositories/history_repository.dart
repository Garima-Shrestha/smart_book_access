import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/services/connectivity/network_info.dart';
import 'package:smart_book_access/features/history/data/datasources/history_datasource.dart';
import 'package:smart_book_access/features/history/data/datasources/local/history_local_datasource.dart';
import 'package:smart_book_access/features/history/data/datasources/remote/history_remote_datasource.dart';
import 'package:smart_book_access/features/history/data/models/history_api_model.dart';
import 'package:smart_book_access/features/history/data/models/history_hive_model.dart';
import 'package:smart_book_access/features/history/domain/entities/history_entity.dart';
import 'package:smart_book_access/features/history/domain/repositories/history_repository.dart';

// Provider
final historyRepositoryProvider = Provider<IHistoryRepository>((ref) {
  final historyLocalDataSource = ref.read(historyLocalDataSourceProvider);
  final historyRemoteDataSource = ref.read(historyRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return HistoryRepository(
    historyLocalDataSource: historyLocalDataSource,
    historyRemoteDataSource: historyRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class HistoryRepository implements IHistoryRepository {
  final IHistoryLocalDataSource _historyLocalDataSource;
  final IHistoryRemoteDataSource _historyRemoteDataSource;
  final NetworkInfo _networkInfo;

  HistoryRepository({
    required IHistoryLocalDataSource historyLocalDataSource,
    required IHistoryRemoteDataSource historyRemoteDataSource,
    required NetworkInfo networkInfo,
  })  : _historyLocalDataSource = historyLocalDataSource,
        _historyRemoteDataSource = historyRemoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<HistoryEntity>>> getMyHistory({
    int page = 1,
    int size = 10,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        // 1. Get from Remote (positional parameters)
        final apiModels =
        await _historyRemoteDataSource.getMyHistory(page, size);

        if (page == 1) {
          await _historyLocalDataSource.clearHistoryCache();
        }

        // 2. Cache to Hive
        final hiveModels = apiModels
            .map((apiModel) =>
            HistoryHiveModel.fromEntity(apiModel.toEntity()))
            .toList();

        await _historyLocalDataSource.cacheHistory(hiveModels);

        return Right(HistoryApiModel.toEntityList(apiModels));
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch history',
          statusCode: e.response?.statusCode,
        ));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModels =
        await _historyLocalDataSource.getCachedHistory();
        final entities =
        HistoryHiveModel.toEntityList(hiveModels);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}