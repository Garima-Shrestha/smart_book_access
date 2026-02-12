import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/auth/data/repositories/auth_repository.dart';
import 'package:smart_book_access/features/auth/domain/repositories/auth_repository.dart';

final forgotPasswordUsecaseProvider = Provider<ForgotPasswordUsecase>((ref) {
  return ForgotPasswordUsecase(authRepository: ref.read(authRepositoryProvider));
});

class ForgotPasswordUsecase implements UsecaseWithParams<bool, String> {
  final IAuthRepository _authRepository;

  ForgotPasswordUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(String email) {
    return _authRepository.forgotPassword(email);
  }
}