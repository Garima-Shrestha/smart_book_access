import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_book_access/core/api/api_client.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/services/storage/token_service.dart';
import 'package:smart_book_access/features/library/data/datasources/my_library_datasource.dart';
import 'package:smart_book_access/features/library/data/models/my_library_api_model.dart';

// Provider
final myLibraryRemoteDataSourceProvider =
Provider<IMyLibraryRemoteDataSource>((ref) {
  return MyLibraryRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class MyLibraryRemoteDataSource implements IMyLibraryRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  MyLibraryRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  @override
  Future<List<MyLibraryApiModel>> getMyLibrary({
    int page = 1,
    int size = 10,
  }) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.getMyLibrary,
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

    if (response.data['success'] == true) {
      final data = response.data['data'];

      if (data is List) {
        return data
            .map((e) =>
            MyLibraryApiModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    return [];
  }
}