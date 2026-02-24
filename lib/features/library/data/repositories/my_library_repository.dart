import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/services/connectivity/network_info.dart';
import 'package:smart_book_access/features/library/data/datasources/local/my_library_local_datasource.dart';
import 'package:smart_book_access/features/library/data/datasources/my_library_datasource.dart';
import 'package:smart_book_access/features/library/data/datasources/remote/my_library_remote_datasource.dart';
import 'package:smart_book_access/features/library/data/models/my_library_api_model.dart';
import 'package:smart_book_access/features/library/data/models/my_library_hive_model.dart';
import 'package:smart_book_access/features/library/domain/entities/my_library_entity.dart';
import 'package:smart_book_access/features/library/domain/repositories/my_library_repository.dart';

// Provider
final myLibraryRepositoryProvider = Provider<IMyLibraryRepository>((ref) {
  final localDataSource = ref.read(myLibraryLocalDataSourceProvider);
  final remoteDataSource = ref.read(myLibraryRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return MyLibraryRepository(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class MyLibraryRepository implements IMyLibraryRepository {
  final IMyLibraryLocalDataSource _localDataSource;
  final IMyLibraryRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  MyLibraryRepository({
    required IMyLibraryLocalDataSource localDataSource,
    required IMyLibraryRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<MyLibraryEntity>>> getMyLibrary({
    int page = 1,
    int size = 10,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModels =
        await _remoteDataSource.getMyLibrary(page: page, size: size);

        final entities = MyLibraryApiModel.toEntityList(apiModels);
        final hiveModels = entities.map((e) => MyLibraryHiveModel.fromEntity(e)).toList();
        await _localDataSource.cacheMyLibrary(hiveModels);

        return Right(entities);
      } on DioException catch (e) {
        final serverMessage =
        (e.response?.data is Map && (e.response?.data as Map)['message'] != null)
            ? (e.response?.data as Map)['message'].toString()
            : null;

        return Left(
          ApiFailure(
            message: serverMessage ?? 'Failed to fetch my library',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    }

    else {
      try {
        final cachedModels = await _localDataSource.getCachedMyLibrary();
        final entities = MyLibraryHiveModel.toEntityList(cachedModels);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}