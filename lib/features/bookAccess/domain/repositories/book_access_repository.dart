import 'package:dartz/dartz.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';

abstract interface class IBookAccessRepository {
  Future<Either<Failure, BookAccessEntity>> getBookAccess(String bookId);
  Future<Either<Failure, List<BookAccessEntity>>> getUserBooks();

  Future<Either<Failure, BookAccessEntity>> addBookmark(String bookId, BookmarkEntity bookmark);
  Future<Either<Failure, BookAccessEntity>> removeBookmark(String bookId, int index);

  Future<Either<Failure, BookAccessEntity>> addQuote(String bookId, QuoteEntity quote);
  Future<Either<Failure, BookAccessEntity>> removeQuote(String bookId, int index);

  Future<Either<Failure, BookAccessEntity>> updateLastPosition(String bookId, LastPositionEntity lastPosition);
}