import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/splash/data/datasources/local/splash_local_datasource.dart';
import '../../domain/repositories/splash_repository.dart';

final   splashRepositoryProvider = Provider<ISplashRepository>((ref) {
  return SplashRepository(splashDatasource: ref.read(splashLocalDatasourceProvider));
});

class SplashRepository implements ISplashRepository {
  final SplashLocalDataSource _splashDataSource;

  SplashRepository({required SplashLocalDataSource splashDatasource})
      : _splashDataSource = splashDatasource;

  @override
  Future<Either<Failure, bool>> isUserLoggedIn() async {
    try{
      final loggedIn = await _splashDataSource.isUserLoggedIn();
      return Right(loggedIn);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}