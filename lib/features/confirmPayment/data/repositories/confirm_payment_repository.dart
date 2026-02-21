import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/services/connectivity/network_info.dart';
import 'package:smart_book_access/features/confirmPayment/data/datasources/confirm_payment_datasource.dart';
import 'package:smart_book_access/features/confirmPayment/data/datasources/remote/confirm_payment_remote_datasource.dart';
import 'package:smart_book_access/features/confirmPayment/data/models/confirm_payment_api_model.dart';
import 'package:smart_book_access/features/confirmPayment/domain/entities/confirm_payment_entity.dart';
import 'package:smart_book_access/features/confirmPayment/domain/repositories/confirm_payment_repository.dart';

// Provider
final confirmPaymentRepositoryProvider = Provider<IConfirmPaymentRepository>((ref) {
  final remoteDataSource = ref.read(confirmPaymentRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ConfirmPaymentRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class ConfirmPaymentRepositoryImpl implements IConfirmPaymentRepository {
  final IConfirmPaymentRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ConfirmPaymentRepositoryImpl({
    required IConfirmPaymentRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> rentBook(RentalEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = ConfirmPaymentApiModel.fromEntity(entity);
        final result = await _remoteDataSource.rentBook(apiModel);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Rental failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(
        ApiFailure(message: "No internet connection. Please go online to rent books."),
      );
    }
  }
}