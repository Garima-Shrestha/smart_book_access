import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/book/data/repositories/book_repository.dart';
import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';
import 'package:smart_book_access/features/book/domain/repositories/book_repository.dart';

final getAllBooksUsecaseProvider = Provider<GetAllBooksUsecase>((ref) {
  return GetAllBooksUsecase(bookRepository: ref.read(bookRepositoryProvider));
});

class GetAllBooksParams extends Equatable {
  final int page;
  final int size;
  final String? searchTerm;

  const GetAllBooksParams({
    required this.page,
    required this.size,
    this.searchTerm,
  });

  @override
  List<Object?> get props => [page, size, searchTerm];
}

class GetAllBooksUsecase implements UsecaseWithParams<List<BookEntity>, GetAllBooksParams> {
  final IBookRepository _bookRepository;

  GetAllBooksUsecase({required IBookRepository bookRepository})
      : _bookRepository = bookRepository;

  @override
  Future<Either<Failure, List<BookEntity>>> call(GetAllBooksParams params) {
    return _bookRepository.getAllBooks(
      page: params.page,
      size: params.size,
      searchTerm: params.searchTerm,
    );
  }
}