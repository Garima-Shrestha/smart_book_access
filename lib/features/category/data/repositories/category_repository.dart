import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/services/connectivity/network_info.dart';
import 'package:smart_book_access/features/category/data/datasources/category_datasource.dart';
import 'package:smart_book_access/features/category/data/datasources/local/category_local_datasource.dart';
import 'package:smart_book_access/features/category/data/datasources/remote/category_remote_datasource.dart';
import 'package:smart_book_access/features/category/data/models/category_api_model.dart';
import 'package:smart_book_access/features/category/data/models/category_hive_model.dart';
import 'package:smart_book_access/features/category/domain/entities/category_entity.dart';
import 'package:smart_book_access/features/category/domain/repositories/category_repository.dart';

// Provider
final categoryRepositoryProvider = Provider<ICategoryRepository>((ref) {
  final localDataSource = ref.read(categoryLocalDataSourceProvider);
  final remoteDataSource = ref.read(categoryRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return CategoryRepository(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class CategoryRepository implements ICategoryRepository {
  final ICategoryLocalDataSource _localDataSource;
  final ICategoryRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  CategoryRepository({
    required ICategoryLocalDataSource localDataSource,
    required ICategoryRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModels = await _remoteDataSource.getAllCategories();
        final entities = apiModels.map((model) => model.toEntity()).toList();

        final hiveModels = entities.map((entity) => CategoryHiveModel.fromEntity(entity)).toList();
        await _localDataSource.addAllCategories(hiveModels);

        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to fetch categories',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModels = await _localDataSource.getAllCategories();
        final entities = hiveModels.map((model) => model.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id) async {
    try {
      final apiModel = await _remoteDataSource.getCategoryById(id);
      return Right(apiModel.toEntity());
    } on DioException catch (e) {
      return Left(ApiFailure(message: e.toString()));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}