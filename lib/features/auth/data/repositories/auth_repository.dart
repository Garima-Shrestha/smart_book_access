import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/auth/data/datasources/auth_datasource.dart';
import 'package:lost_n_found/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:lost_n_found/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:lost_n_found/features/auth/data/models/auth_api_model.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/auth/domain/repositories/auth_repository.dart';

// Provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.read(authLocalDataSourceProvider);
  final authRemoteDatasource = ref.read(authRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AuthRepository(
    authDatasource: authDatasource,
    authRemoteDataSource: authRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDataSource _authDataSource;
  final IAuthRemoteDataSource _authRemoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDataSource authDatasource,
    required IAuthRemoteDataSource authRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _authDataSource = authDatasource,
        _authRemoteDataSource = authRemoteDataSource,
        _networkInfo = networkInfo;



  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(entity);
        await _authRemoteDataSource.register(apiModel);
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Registration failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        // check if email locally exist garxa ki gardaina
        final existingUser = await _authDataSource.isEmailExists(entity.email);
        if (existingUser) {
          return const Left(
            LocalDatabaseFailure(message: "Email already registered"),
          );
        }

        final model = AuthHiveModel.fromEntity(entity);
        await _authDataSource.register(model);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(String email, String password) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDataSource.login(email, password);
        if (apiModel != null) {
          final entity = apiModel.toEntity();
          return Right(entity);
        }
        return const Left(ApiFailure(message: "Invalid credentials"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Login failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try{
        final model = await _authDataSource.login(email, password);
        if (model != null) {
          final entity = model.toEntity();
          return Right(entity);
        }
        return Left(LocalDatabaseFailure(message:  'Failed to login user'));
      } catch (e) {
        return Left(LocalDatabaseFailure(message:  e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try{
      final user = await _authDataSource.getCurrentUser();
      if (user != null) {
        final entity = user.toEntity();
        return Right(entity);
      }
      return Left(LocalDatabaseFailure(message:  'No user logged in'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message:  e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try{
      final result = await _authDataSource.logout();
      if (result) {
        return const Right(true);
      }
      return const Left(LocalDatabaseFailure(message:  'Failed to logout user'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message:  e.toString()));
    }
  }
}