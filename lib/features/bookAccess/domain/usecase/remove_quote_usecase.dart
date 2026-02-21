import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/bookAccess/data/repositories/book_access_repository.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
import 'package:smart_book_access/features/bookAccess/domain/repositories/book_access_repository.dart';

final removeQuoteUsecaseProvider = Provider<RemoveQuoteUsecase>((ref) {
  return RemoveQuoteUsecase(repository: ref.read(bookAccessRepositoryProvider));
});

class RemoveQuoteParams extends Equatable {
  final String bookId;
  final int index;

  const RemoveQuoteParams({required this.bookId, required this.index});

  @override
  List<Object?> get props => [bookId, index];
}

class RemoveQuoteUsecase implements UsecaseWithParams<BookAccessEntity, RemoveQuoteParams> {
  final IBookAccessRepository _repository;

  RemoveQuoteUsecase({required IBookAccessRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, BookAccessEntity>> call(RemoveQuoteParams params) {
    return _repository.removeQuote(params.bookId, params.index);
  }
}