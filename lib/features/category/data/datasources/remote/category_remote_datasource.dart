import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/api/api_client.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/services/storage/token_service.dart';
import 'package:smart_book_access/features/category/data/models/category_api_model.dart';
import 'package:smart_book_access/features/category/data/datasources/category_datasource.dart';

// Provider
final categoryRemoteDataSourceProvider = Provider<ICategoryRemoteDataSource>((ref) {
  return CategoryRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class CategoryRemoteDataSource implements ICategoryRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  CategoryRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  @override
  Future<List<CategoryApiModel>> getAllCategories() async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.getAllCategories,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
    );

    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data
          .map((category) => CategoryApiModel.fromJson(category))
          .toList();
    }
    return [];
  }

  @override
  Future<CategoryApiModel> getCategoryById(String id) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.getCategoryById(id),
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return CategoryApiModel.fromJson(data);
    }

    throw Exception("Category not found");
  }
}