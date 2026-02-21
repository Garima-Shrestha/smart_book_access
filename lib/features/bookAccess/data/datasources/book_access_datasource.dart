import 'package:smart_book_access/features/bookAccess/data/models/book_access_api_model.dart';
import 'package:smart_book_access/features/bookAccess/data/models/book_access_hive_model.dart';

abstract interface class IBookAccessLocalDataSource {
  Future<void> saveBookAccess(BookAccessHiveModel model);
  Future<BookAccessHiveModel?> getBookAccess(String bookId);
  Future<void> clearAll();

  Future<void> addBookmark(String bookId, BookmarkHiveModel bookmark);
  Future<void> removeBookmark(String bookId, int index);
  Future<void> addQuote(String bookId, QuoteHiveModel quote);
  Future<void> removeQuote(String bookId, int index);
  Future<void> updateLastPosition(String bookId, LastPositionHiveModel lastPosition);
}

abstract interface class IBookAccessRemoteDataSource {
  Future<BookAccessApiModel> getBookAccess(String bookId);
  Future<List<BookAccessApiModel>> getUserBooks();

  Future<BookAccessApiModel> addBookmark(String bookId, BookmarkApiModel bookmark);
  Future<BookAccessApiModel> removeBookmark(String bookId, int index);

  Future<BookAccessApiModel> addQuote(String bookId, QuoteApiModel quote);
  Future<BookAccessApiModel> removeQuote(String bookId, int index);

  Future<BookAccessApiModel> updateLastPosition(String bookId, LastPositionApiModel lastPosition);
}