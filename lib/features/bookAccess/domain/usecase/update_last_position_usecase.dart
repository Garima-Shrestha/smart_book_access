import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/bookAccess/data/repositories/book_access_repository.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
import 'package:smart_book_access/features/bookAccess/domain/repositories/book_access_repository.dart';

final updateLastPositionUsecaseProvider = Provider<UpdateLastPositionUsecase>((ref) {
  return UpdateLastPositionUsecase(repository: ref.read(bookAccessRepositoryProvider));
});

class PositionParams extends Equatable {
  final String bookId;
  final LastPositionEntity position;

  const PositionParams({required this.bookId, required this.position});

  @override
  List<Object?> get props => [bookId, position];
}

class UpdateLastPositionUsecase implements UsecaseWithParams<BookAccessEntity, PositionParams> {
  final IBookAccessRepository _repository;

  UpdateLastPositionUsecase({required IBookAccessRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, BookAccessEntity>> call(PositionParams params) {
    return _repository.updateLastPosition(params.bookId, params.position);
  }
}