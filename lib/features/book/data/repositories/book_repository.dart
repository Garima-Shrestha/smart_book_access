import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/services/connectivity/network_info.dart';
import 'package:smart_book_access/features/book/data/datasources/book_datasource.dart';
import 'package:smart_book_access/features/book/data/datasources/local/book_local_datasource.dart';
import 'package:smart_book_access/features/book/data/datasources/remote/book_remote_datasource.dart';
import 'package:smart_book_access/features/book/data/models/book_api_model.dart';
import 'package:smart_book_access/features/book/data/models/book_hive_model.dart';
import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';
import 'package:smart_book_access/features/book/domain/repositories/book_repository.dart';

// Provider
final bookRepositoryProvider = Provider<IBookRepository>((ref) {
  final bookLocalDataSource = ref.read(bookLocalDataSourceProvider);
  final bookRemoteDataSource = ref.read(bookRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return BookRepository(
    bookLocalDataSource: bookLocalDataSource,
    bookRemoteDataSource: bookRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class BookRepository implements IBookRepository {
  final IBookLocalDataSource _bookLocalDataSource;
  final IBookRemoteDataSource _bookRemoteDataSource;
  final NetworkInfo _networkInfo;

  BookRepository({
    required IBookLocalDataSource bookLocalDataSource,
    required IBookRemoteDataSource bookRemoteDataSource,
    required NetworkInfo networkInfo,
  })  : _bookLocalDataSource = bookLocalDataSource,
        _bookRemoteDataSource = bookRemoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<BookEntity>>> getAllBooks({
    int page = 1,
    int size = 10,
    String? searchTerm,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        // 1. Get from Remote
        final apiModels = await _bookRemoteDataSource.getAllBooks(
          page: page,
          size: size,
          searchTerm: searchTerm,
        );

        if (page == 1) {
          await _bookLocalDataSource.clearBookBox();
        }

        final hiveModels = apiModels
            .map((apiModel) => BookHiveModel.fromEntity(apiModel.toEntity()))
            .toList();
        await _bookLocalDataSource.addAllBooks(hiveModels);

        return Right(BookApiModel.toEntityList(apiModels));
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch books',
          statusCode: e.response?.statusCode,
        ));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModels = await _bookLocalDataSource.getAllBooks();
        final entities = BookHiveModel.toEntityList(hiveModels);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, BookEntity>> getBookById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _bookRemoteDataSource.getBookById(id);
        return Right(apiModel.toEntity());
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch book details',
          statusCode: e.response?.statusCode,
        ));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModel = await _bookLocalDataSource.getBookById(id);
        if (hiveModel != null) {
          return Right(hiveModel.toEntity());
        }
        return const Left(LocalDatabaseFailure(message: "Book not found in cache"));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> getBooksByCategory(String categoryId) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModels = await _bookRemoteDataSource.getBooksByCategory(categoryId);
        return Right(BookApiModel.toEntityList(apiModels));
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch category books',
          statusCode: e.response?.statusCode,
        ));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModels = await _bookLocalDataSource.getAllBooks();
        final filteredBooks = hiveModels
            .where((book) => book.genre == categoryId) // genre stores categoryId
            .toList();
        return Right(BookHiveModel.toEntityList(filteredBooks));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}