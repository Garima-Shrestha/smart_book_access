import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/api/api_client.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/services/storage/token_service.dart';
import 'package:smart_book_access/core/services/storage/user_session_service.dart';
import 'package:smart_book_access/features/khalti/data/datasources/khalti_datasource.dart';
import 'package:smart_book_access/features/khalti/data/models/khalti_api_model.dart';

// Provider
final khaltiRemoteDataSourceProvider = Provider<IKhaltiRemoteDataSource>((ref) {
  return KhaltiRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class KhaltiRemoteDataSource implements IKhaltiRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;
  final UserSessionService _userSessionService;

  KhaltiRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
    required UserSessionService userSessionService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService,
        _userSessionService = userSessionService;

  @override
  Future<KhaltiInitiateResponseApiModel> initiatePayment(
      KhaltiInitiateRequestApiModel request,
      ) async {
    final token = _tokenService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token missing. Please login again.");
    }

    final response = await _apiClient.post(
      ApiEndpoints.khaltiInitiate,
      data: request.toJson(),
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return KhaltiInitiateResponseApiModel.fromJson(data);
    }

    throw Exception(response.data['message'] ?? "Failed to initiate Khalti payment");
  }

  @override
  Future<KhaltiVerifyResponseApiModel> verifyPayment(
      KhaltiVerifyRequestApiModel request,
      ) async {
    final token = _tokenService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token missing. Please login again.");
    }

    final response = await _apiClient.post(
      ApiEndpoints.khaltiVerify,
      data: request.toJson(), 
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return KhaltiVerifyResponseApiModel.fromJson(data);
    }

    throw Exception(response.data['message'] ?? "Failed to verify Khalti payment");
  }
}