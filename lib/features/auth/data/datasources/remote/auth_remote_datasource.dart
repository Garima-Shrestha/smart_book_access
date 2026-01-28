import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/api/api_client.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/services/storage/token_service.dart';
import 'package:smart_book_access/core/services/storage/user_session_service.dart';
import 'package:smart_book_access/features/auth/data/datasources/auth_datasource.dart';
import 'package:smart_book_access/features/auth/data/models/auth_api_model.dart';

// Provider
final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  })
      : _apiClient = apiClient,
        _userSessionService = userSessionService,
        _tokenService = tokenService;

  @override
  Future<AuthApiModel?> getUserById(String authId) async {
    final response = await _apiClient.get(
      ApiEndpoints.authById(authId),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return AuthApiModel.fromJson(data);
    }

    return null;
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);

      // Save user session
      await _userSessionService.saveUserSession(
        userId: user.id!,
        username: user.username,
        email: user.email,
        countryCode: user.countryCode,
        phoneNumber: user.phone,
        imageUrl: user.imageUrl,
      );

      // save token
      final token = response.data['token'] as String?;
      await _tokenService.saveToken(token!);
      // if (token != null) {
      //   await _tokenService.saveToken(token);
      // }

      return user;
    }
    return null;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthApiModel.fromJson(data);
      return registeredUser;
    }

    return user;
  }

  @override
  Future<bool> updateProfile(AuthApiModel user, File? imageUrl) async {
      final token = await _tokenService.getToken();

      Map<String, dynamic> formDataMap = {
        "id": user.id,
        "username": user.username,
        "email": user.email,
        "phone": user.phone,
        "countryCode": user.countryCode,
      };

      if (imageUrl != null) {
        formDataMap["image"] = await MultipartFile.fromFile(
          imageUrl.path,
          filename: imageUrl.path.split('/').last,
        );
      }

      FormData formData = FormData.fromMap(formDataMap);

      final response = await _apiClient.putMultipart(
        ApiEndpoints.updateProfile,
        formData: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final updatedImageUrl = response.data['data']['image'] ?? user.imageUrl;

        await _userSessionService.saveUserSession(
          // userId: user.id!,
          userId: user.id ?? '',
          username: user.username,
          email: user.email,
          countryCode: user.countryCode,
          phoneNumber: user.phone,
          imageUrl: updatedImageUrl,
        );
        return true;
      }
      return false;
  }
}