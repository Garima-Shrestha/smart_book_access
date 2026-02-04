import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/services/connectivity/network_info.dart';
import 'package:smart_book_access/features/auth/data/datasources/auth_datasource.dart';
import 'package:smart_book_access/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:smart_book_access/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:smart_book_access/features/auth/data/models/auth_api_model.dart';
import 'package:smart_book_access/features/auth/data/models/auth_hive_model.dart';
import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';
import 'package:smart_book_access/features/auth/domain/repositories/auth_repository.dart';

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

  @override
  Future<Either<Failure, bool>> updateProfile(AuthEntity entity, {File? imageUrl}) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(entity);
        final result = await _authRemoteDataSource.updateProfile(apiModel, imageUrl);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Profile update failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = AuthHiveModel.fromEntity(entity);
        final result = await _authDataSource.updateProfile(model);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword(String oldPassword, String newPassword) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authRemoteDataSource.changePassword(oldPassword, newPassword);

        // If remote success, also update local password so offline login stays in sync
        if (result) {
          await _authDataSource.updatePassword(newPassword);
        }

        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to change password',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: "No internet connection to change password"));
    }
  }
}