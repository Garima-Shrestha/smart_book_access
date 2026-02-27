import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/services/connectivity/network_info.dart';

import 'package:smart_book_access/features/khalti/data/datasources/khalti_datasource.dart';
import 'package:smart_book_access/features/khalti/data/datasources/remote/khalti_remote_datasource.dart';
import 'package:smart_book_access/features/khalti/data/models/khalti_api_model.dart';
import 'package:smart_book_access/features/khalti/domain/entities/khalti_entity.dart';
import 'package:smart_book_access/features/khalti/domain/repositories/khalti_repository.dart';

// Provider
final khaltiRepositoryProvider = Provider<IKhaltiRepository>((ref) {
  final remote = ref.read(khaltiRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return KhaltiRepository(
    khaltiRemoteDataSource: remote,
    networkInfo: networkInfo,
  );
});

class KhaltiRepository implements IKhaltiRepository {
  final IKhaltiRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  KhaltiRepository({
    required IKhaltiRemoteDataSource khaltiRemoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = khaltiRemoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, KhaltiInitiateResponseEntity>> initiatePayment(
      KhaltiPaymentEntity entity,
      ) async {
    if (await _networkInfo.isConnected) {
      try {
        final req = KhaltiInitiateRequestApiModel.fromEntity(entity);
        final res = await _remote.initiatePayment(req);
        return Right(res.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to initiate Khalti payment',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(
        ApiFailure(message: "No internet connection. Khalti payment requires internet."),
      );
    }
  }

  @override
  Future<Either<Failure, KhaltiVerifyResponseEntity>> verifyPayment(
      String pidx,
      ) async {
    if (await _networkInfo.isConnected) {
      try {
        final req = KhaltiVerifyRequestApiModel(pidx: pidx);
        final res = await _remote.verifyPayment(req);
        return Right(res.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to verify Khalti payment',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(
        ApiFailure(message: "No internet connection. Khalti verification requires internet."),
      );
    }
  }
}