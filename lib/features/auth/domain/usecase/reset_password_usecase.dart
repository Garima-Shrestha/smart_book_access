import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/auth/data/repositories/auth_repository.dart';
import 'package:smart_book_access/features/auth/domain/repositories/auth_repository.dart';

final resetPasswordUsecaseProvider = Provider<ResetPasswordUsecase>((ref) {
  return ResetPasswordUsecase(authRepository: ref.read(authRepositoryProvider));
});

class ResetPasswordParams extends Equatable {
  final String token;
  final String password;

  const ResetPasswordParams({required this.token, required this.password});

  @override
  List<Object?> get props => [token, password];
}

class ResetPasswordUsecase implements UsecaseWithParams<bool, ResetPasswordParams> {
  final IAuthRepository _authRepository;

  ResetPasswordUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(ResetPasswordParams params) {
    return _authRepository.resetPassword(params.token, params.password);
  }
}