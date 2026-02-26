import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/api/api_client.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/services/storage/token_service.dart';
import 'package:smart_book_access/features/history/data/datasources/history_datasource.dart';
import 'package:smart_book_access/features/history/data/models/history_api_model.dart';

// Provider
final historyRemoteDataSourceProvider =
Provider<IHistoryRemoteDataSource>((ref) {
  return HistoryRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class HistoryRemoteDatasource implements IHistoryRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  HistoryRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  @override
  Future<List<HistoryApiModel>> getMyHistory(int page, int size) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.getMyHistory,
      queryParameters: {
        'page': page,
        'size': size,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.statusCode == 200 &&
        response.data['success'] == true) {
      final data = response.data['data'] as List<dynamic>;

      return data
          .map((e) => HistoryApiModel.fromJson(
          e as Map<String, dynamic>))
          .toList();
    }

    return [];
  }
}