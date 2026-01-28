import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';
import 'package:smart_book_access/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_book_access/features/auth/data/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  return UpdateProfileUsecase(authRepository: ref.read(authRepositoryProvider));
});

class UpdateProfileUsecaseParams extends Equatable {
  final String username;
  final String email;
  final String countryCode;
  final String phone;
  final File? imageUrl;

  const UpdateProfileUsecaseParams({
    required this.username,
    required this.email,
    required this.countryCode,
    required this.phone,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [username, email, countryCode, phone, imageUrl];
}

class UpdateProfileUsecase
    implements UsecaseWithParams<bool, UpdateProfileUsecaseParams> {
  final IAuthRepository _authRepository;

  UpdateProfileUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateProfileUsecaseParams params) {
    final entity = AuthEntity(
      username: params.username,
      email: params.email,
      countryCode: params.countryCode,
      phone: params.phone,
    );
    return _authRepository.updateProfile(entity, imageUrl: params.imageUrl);
  }
}