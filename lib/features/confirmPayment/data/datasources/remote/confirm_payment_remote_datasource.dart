import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_book_access/core/api/api_client.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/services/storage/token_service.dart';
import 'package:smart_book_access/core/services/storage/user_session_service.dart';
import 'package:smart_book_access/features/confirmPayment/data/datasources/confirm_payment_datasource.dart';
import 'package:smart_book_access/features/confirmPayment/data/models/confirm_payment_api_model.dart';

final confirmPaymentRemoteDataSourceProvider =
Provider<IConfirmPaymentRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final SharedPreferences prefs = ref.read(sharedPreferencesProvider);
  final tokenService = TokenService(prefs: prefs);

  return ConfirmPaymentRemoteDataSource(
    apiClient: apiClient,
    tokenService: tokenService,
  );
});

class ConfirmPaymentRemoteDataSource implements IConfirmPaymentRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ConfirmPaymentRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  @override
  Future<bool> rentBook(ConfirmPaymentApiModel rental) async {
    final token = _tokenService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Token missing. Please login again.");
    }

    final response = await _apiClient.post(
      ApiEndpoints.rentBook(rental.bookId),
      data: rental.toJson(),
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data['success'] == true;
  }
}