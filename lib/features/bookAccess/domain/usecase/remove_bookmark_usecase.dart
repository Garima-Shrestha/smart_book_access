import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/bookAccess/data/repositories/book_access_repository.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
import 'package:smart_book_access/features/bookAccess/domain/repositories/book_access_repository.dart';

final removeBookmarkUsecaseProvider = Provider<RemoveBookmarkUsecase>((ref) {
  return RemoveBookmarkUsecase(repository: ref.read(bookAccessRepositoryProvider));
});

class RemoveBookmarkParams extends Equatable {
  final String bookId;
  final int index;

  const RemoveBookmarkParams({required this.bookId, required this.index});

  @override
  List<Object?> get props => [bookId, index];
}

class RemoveBookmarkUsecase implements UsecaseWithParams<BookAccessEntity, RemoveBookmarkParams> {
  final IBookAccessRepository _repository;

  RemoveBookmarkUsecase({required IBookAccessRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, BookAccessEntity>> call(RemoveBookmarkParams params) {
    return _repository.removeBookmark(params.bookId, params.index);
  }
}