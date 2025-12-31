import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/usecase/app_usecase.dart';
import 'package:lost_n_found/features/auth/data/repositories/auth_repository.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/auth/domain/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';


final registerUsecaseProvider = Provider<RegisterUsecase>((ref){
  return RegisterUsecase(authRepository: ref.read(authRepositoryProvider));
});

class RegisterUsecaseParams extends Equatable{
  final String name;
  final String email;
  final String phone;
  final String password;

  const RegisterUsecaseParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
});
  @override
  List<Object?> get props => [name, email, phone, password];
}

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams>{

  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
        name: params.name,
        email: params.email,
        phone: params.phone,
        password: params.password,
    );
    return _authRepository.register(entity);
  }
}

