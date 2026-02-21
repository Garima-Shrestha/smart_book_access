import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/bookAccess/data/repositories/book_access_repository.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
import 'package:smart_book_access/features/bookAccess/domain/repositories/book_access_repository.dart';

final addQuoteUsecaseProvider = Provider<AddQuoteUsecase>((ref) {
  return AddQuoteUsecase(repository: ref.read(bookAccessRepositoryProvider));
});

class QuoteParams extends Equatable {
  final String bookId;
  final QuoteEntity quote;

  const QuoteParams({required this.bookId, required this.quote});

  @override
  List<Object?> get props => [bookId, quote];
}

class AddQuoteUsecase implements UsecaseWithParams<BookAccessEntity, QuoteParams> {
  final IBookAccessRepository _repository;

  AddQuoteUsecase({required IBookAccessRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, BookAccessEntity>> call(QuoteParams params) {
    return _repository.addQuote(params.bookId, params.quote);
  }
}