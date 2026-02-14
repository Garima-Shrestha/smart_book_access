import 'package:smart_book_access/features/book/data/models/book_api_model.dart';
import 'package:smart_book_access/features/book/data/models/book_hive_model.dart';

abstract interface class IBookLocalDataSource {
  Future<bool> addAllBooks(List<BookHiveModel> models);
  Future<List<BookHiveModel>> getAllBooks();
  Future<BookHiveModel?> getBookById(String id);
  Future<bool> clearBookBox();
}

abstract interface class IBookRemoteDataSource {
  Future<List<BookApiModel>> getAllBooks({
    required int page,
    required int size,
    String? searchTerm,
  });

  Future<BookApiModel> getBookById(String id);
  Future<List<BookApiModel>> getBooksByCategory(String categoryId);
}