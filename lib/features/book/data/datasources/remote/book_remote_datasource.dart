import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/api/api_client.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/services/storage/token_service.dart';
import 'package:smart_book_access/features/book/data/datasources/book_datasource.dart';
import 'package:smart_book_access/features/book/data/models/book_api_model.dart';

final bookRemoteDataSourceProvider = Provider<IBookRemoteDataSource>((ref) {
  return BookRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class BookRemoteDataSource implements IBookRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  BookRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  @override
  Future<List<BookApiModel>> getAllBooks({
    required int page,
    required int size,
    String? searchTerm,
  }) async {
    final token = await _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.getAllBooks,
      queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
        if (searchTerm != null && searchTerm.isNotEmpty) 'searchTerm': searchTerm,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => BookApiModel.fromJson(json)).toList();
    }

    return [];
  }

  @override
  Future<BookApiModel> getBookById(String id) async {
    final token = await _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.getBookById(id),
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return BookApiModel.fromJson(data);
    }
    throw Exception(response.data['message'] ?? 'Book not found');
  }

  @override
  Future<List<BookApiModel>> getBooksByCategory(String categoryId) async {
    final token = await _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.getAllBooks,
      queryParameters: {
        'genre': categoryId,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => BookApiModel.fromJson(json)).toList();
    }

    return [];
  }
}