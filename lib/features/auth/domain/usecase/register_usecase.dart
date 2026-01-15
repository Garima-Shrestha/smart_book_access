import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/auth/data/repositories/auth_repository.dart';
import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';
import 'package:smart_book_access/features/auth/domain/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';


final registerUsecaseProvider = Provider<RegisterUsecase>((ref){
  return RegisterUsecase(authRepository: ref.read(authRepositoryProvider));
});

class RegisterUsecaseParams extends Equatable{
  final String username;
  final String email;
  final String countryCode;
  final String phone;
  final String password;

  const RegisterUsecaseParams({
    required this.username,
    required this.email,
    required this.countryCode,
    required this.phone,
    required this.password,
});
  @override
  List<Object?> get props => [username, email, countryCode, phone, password];
}

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams>{

  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
        username: params.username,
        email: params.email,
        countryCode: params.countryCode,
        phone: params.phone,
        password: params.password,
    );
    return _authRepository.register(entity);
  }
}

