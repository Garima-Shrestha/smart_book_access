import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity entity);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, bool>> updateProfile(AuthEntity entity, {File? imageUrl});
  Future<Either<Failure, bool>> changePassword(String oldPassword, String newPassword);
}