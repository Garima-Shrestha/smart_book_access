import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/book/data/repositories/book_repository.dart';
import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';
import 'package:smart_book_access/features/book/domain/repositories/book_repository.dart';

final getBookByIdUsecaseProvider = Provider<GetBookByIdUsecase>((ref) {
  return GetBookByIdUsecase(bookRepository: ref.read(bookRepositoryProvider));
});

class GetBookByIdUsecase implements UsecaseWithParams<BookEntity, String> {
  final IBookRepository _bookRepository;

  GetBookByIdUsecase({required IBookRepository bookRepository})
      : _bookRepository = bookRepository;

  @override
  Future<Either<Failure, BookEntity>> call(String bookId) {
    return _bookRepository.getBookById(bookId);
  }
}