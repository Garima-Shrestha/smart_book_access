import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/bookAccess/data/repositories/book_access_repository.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
import 'package:smart_book_access/features/bookAccess/domain/repositories/book_access_repository.dart';


final addBookmarkUsecaseProvider = Provider<AddBookmarkUsecase>((ref) {
  return AddBookmarkUsecase(repository: ref.read(bookAccessRepositoryProvider));
});

class BookmarkParams extends Equatable {
  final String bookId;
  final BookmarkEntity bookmark;

  const BookmarkParams({required this.bookId, required this.bookmark});

  @override
  List<Object?> get props => [bookId, bookmark];
}

class AddBookmarkUsecase implements UsecaseWithParams<BookAccessEntity, BookmarkParams> {
  final IBookAccessRepository _repository;

  AddBookmarkUsecase({required IBookAccessRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, BookAccessEntity>> call(BookmarkParams params) {
    return _repository.addBookmark(params.bookId, params.bookmark);
  }
}