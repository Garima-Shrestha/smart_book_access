import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/features/splash/domain/repositories/splash_repository.dart';
import 'package:lost_n_found/core/usecase/app_usecase.dart';
import '../../../../core/error/failures.dart';
import '../../data/repositories/splash_repository.dart';

final getInitialPageUsecaseProvider = Provider<GetInitialPageUsecase>((ref) {
  return GetInitialPageUsecase(splashRepository: ref.read(splashRepositoryProvider));
});

class GetInitialPageUsecase implements UsecaseWithoutParams<bool> {
  final ISplashRepository _splashRepository;

  GetInitialPageUsecase({required ISplashRepository splashRepository})
      : _splashRepository = splashRepository;

  @override
  Future<Either<Failure, bool>> call() {
    // Returns true if user is logged in, false otherwise
    return _splashRepository.isUserLoggedIn();
  }
}