import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/bookAccess/data/repositories/book_access_repository.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
import 'package:smart_book_access/features/bookAccess/domain/repositories/book_access_repository.dart';


final getBookAccessUsecaseProvider = Provider<GetBookAccessUsecase>((ref) {
  final bookAccessRepository = ref.read(bookAccessRepositoryProvider);
  return GetBookAccessUsecase(repository: bookAccessRepository);
});

class GetBookAccessUsecase implements UsecaseWithParams<BookAccessEntity, String> {
  final IBookAccessRepository _repository;

  GetBookAccessUsecase({required IBookAccessRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, BookAccessEntity>> call(String bookId) {
    return _repository.getBookAccess(bookId);
  }
}