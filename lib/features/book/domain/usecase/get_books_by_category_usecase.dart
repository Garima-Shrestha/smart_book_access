import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/book/data/repositories/book_repository.dart';
import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';
import 'package:smart_book_access/features/book/domain/repositories/book_repository.dart';

final getBooksByCategoryUsecaseProvider = Provider<GetBooksByCategoryUsecase>((ref) {
  return GetBooksByCategoryUsecase(bookRepository: ref.read(bookRepositoryProvider));
});

class GetBooksByCategoryUsecase implements UsecaseWithParams<List<BookEntity>, String> {
  final IBookRepository _bookRepository;

  GetBooksByCategoryUsecase({required IBookRepository bookRepository})
      : _bookRepository = bookRepository;

  @override
  Future<Either<Failure, List<BookEntity>>> call(String categoryId) {
    return _bookRepository.getBooksByCategory(categoryId);
  }
}