import 'package:dartz/dartz.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/library/domain/entities/my_library_entity.dart';

abstract interface class IMyLibraryRepository {
  Future<Either<Failure, List<MyLibraryEntity>>> getMyLibrary({
    int page = 1,
    int size = 10,
  });
}