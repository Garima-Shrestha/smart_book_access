import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/library/data/repositories/my_library_repository.dart';
import 'package:smart_book_access/features/library/domain/entities/my_library_entity.dart';
import 'package:smart_book_access/features/library/domain/repositories/my_library_repository.dart';

// Provider
final getMyLibraryUsecaseProvider = Provider<GetMyLibraryUsecase>((ref) {
  return GetMyLibraryUsecase(
    myLibraryRepository: ref.read(myLibraryRepositoryProvider),
  );
});

class GetMyLibraryUsecaseParams extends Equatable {
  final int page;
  final int size;

  const GetMyLibraryUsecaseParams({
    this.page = 1,
    this.size = 10,
  });

  @override
  List<Object?> get props => [page, size];
}

class GetMyLibraryUsecase
    implements UsecaseWithParams<List<MyLibraryEntity>, GetMyLibraryUsecaseParams> {
  final IMyLibraryRepository _myLibraryRepository;

  GetMyLibraryUsecase({
    required IMyLibraryRepository myLibraryRepository,
  }) : _myLibraryRepository = myLibraryRepository;

  @override
  Future<Either<Failure, List<MyLibraryEntity>>> call(
      GetMyLibraryUsecaseParams params,
      ) {
    return _myLibraryRepository.getMyLibrary(
      page: params.page,
      size: params.size,
    );
  }
}