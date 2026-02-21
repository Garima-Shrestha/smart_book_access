import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_book_access/core/api/api_client.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/services/storage/token_service.dart';
import 'package:smart_book_access/features/bookAccess/data/datasources/book_access_datasource.dart';
import 'package:smart_book_access/features/bookAccess/data/models/book_access_api_model.dart';

final bookAccessRemoteDataSourceProvider = Provider<IBookAccessRemoteDataSource>((ref) {
  return BookAccessRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class BookAccessRemoteDatasource implements IBookAccessRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  BookAccessRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
        _tokenService = tokenService;

  @override
  Future<BookAccessApiModel> getBookAccess(String bookId) async {
    final token = await _tokenService.getToken();

    final response = await _apiClient.get(
        ApiEndpoints.getBookAccess(bookId),
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return BookAccessApiModel.fromJson(data);
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data['message'] ?? 'Failed to fetch book access',
    );
  }

  @override
  Future<List<BookAccessApiModel>> getUserBooks() async {
    final token = await _tokenService.getToken();

    final response = await _apiClient.get(
        ApiEndpoints.getUserRentedBooks,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.data['success'] == true) {
      final list = response.data['data'] as List<dynamic>;
      return list
          .map((e) => BookAccessApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data['message'] ?? 'Failed to fetch user books',
    );
  }

  @override
  Future<BookAccessApiModel> addBookmark(String bookId, BookmarkApiModel bookmark) async {
    final token = await _tokenService.getToken();

    final response = await _apiClient.post(
      ApiEndpoints.addBookmark(bookId),
      data: bookmark.toJson(),
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return BookAccessApiModel.fromJson(data);
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data['message'] ?? 'Failed to add bookmark',
    );
  }

  @override
  Future<BookAccessApiModel> removeBookmark(String bookId, int index) async {
    final token = await _tokenService.getToken();

    final response = await _apiClient.delete(
      ApiEndpoints.removeBookmark(bookId),
      data: {'index': index},
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return BookAccessApiModel.fromJson(data);
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data['message'] ?? 'Failed to remove bookmark',
    );
  }

  @override
  Future<BookAccessApiModel> addQuote(String bookId, QuoteApiModel quote) async {
    final token = await _tokenService.getToken();

    final response = await _apiClient.post(
      ApiEndpoints.addQuote(bookId),
      data: quote.toJson(),
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return BookAccessApiModel.fromJson(data);
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data['message'] ?? 'Failed to add quote',
    );
  }

  @override
  Future<BookAccessApiModel> removeQuote(String bookId, int index) async {
    final token = await _tokenService.getToken();

    final response = await _apiClient.delete(
      ApiEndpoints.removeQuote(bookId),
      data: {'index': index},
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return BookAccessApiModel.fromJson(data);
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data['message'] ?? 'Failed to remove quote',
    );
  }

  @override
  Future<BookAccessApiModel> updateLastPosition(
      String bookId,
      LastPositionApiModel lastPosition,
      ) async {
    final token = await _tokenService.getToken();

    final response = await _apiClient.patch(
      ApiEndpoints.updateLastPosition(bookId),
      data: lastPosition.toJson(),
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return BookAccessApiModel.fromJson(data);
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data['message'] ?? 'Failed to update last position',
    );
  }
}