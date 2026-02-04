import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_book_access/features/auth/data/repositories/auth_repository.dart';

// Provider
final changePasswordUsecaseProvider = Provider<ChangePasswordUsecase>((ref) {
  return ChangePasswordUsecase(authRepository: ref.read(authRepositoryProvider));
});

// Params
class ChangePasswordParams extends Equatable {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

// Use Case
class ChangePasswordUsecase implements UsecaseWithParams<bool, ChangePasswordParams> {
  final IAuthRepository _authRepository;

  ChangePasswordUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(ChangePasswordParams params) {
    return _authRepository.changePassword(
      params.oldPassword,
      params.newPassword,
    );
  }
}