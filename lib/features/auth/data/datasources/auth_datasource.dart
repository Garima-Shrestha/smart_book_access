import 'dart:io';

import 'package:smart_book_access/features/auth/data/models/auth_api_model.dart';
import 'package:smart_book_access/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthLocalDataSource {
  Future<bool> register(AuthHiveModel model);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();

  // get email exists
  Future<bool> isEmailExists(String email);

  Future<bool> updateProfile(AuthHiveModel model);
}

abstract interface class IAuthRemoteDataSource {
  Future<AuthApiModel> register(AuthApiModel user);
  Future<AuthApiModel?> login(String email, String password);
  Future<AuthApiModel?> getUserById(String authId);

  Future<bool> updateProfile(AuthApiModel user, File? imageUrl);
}