import 'package:dartz/dartz.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/history/domain/entities/history_entity.dart';

abstract interface class IHistoryRepository {
  Future<Either<Failure, List<HistoryEntity>>> getMyHistory({
    int page = 1,
    int size = 10,
  });
}
