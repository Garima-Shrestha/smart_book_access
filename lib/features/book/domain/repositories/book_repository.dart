import 'package:dartz/dartz.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';

abstract interface class IBookRepository {
  Future<Either<Failure, List<BookEntity>>> getAllBooks({
    int page = 1,
    int size = 10,
    String? searchTerm,
  });

  Future<Either<Failure, BookEntity>> getBookById(String id);
  Future<Either<Failure, List<BookEntity>>> getBooksByCategory(String categoryId);
}