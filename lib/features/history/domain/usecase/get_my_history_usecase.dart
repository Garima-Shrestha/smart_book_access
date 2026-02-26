import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/history/data/repositories/history_repository.dart';
import 'package:smart_book_access/features/history/domain/entities/history_entity.dart';
import 'package:smart_book_access/features/history/domain/repositories/history_repository.dart';

// Provider
final getMyHistoryUsecaseProvider = Provider<GetMyHistoryUsecase>((ref) {
  return GetMyHistoryUsecase(historyRepository: ref.read(historyRepositoryProvider));
});

class GetMyHistoryUsecaseParams extends Equatable {
  final int page;
  final int size;

  const GetMyHistoryUsecaseParams({required this.page, required this.size});

  @override
  List<Object?> get props => [page, size];
}

class GetMyHistoryUsecase
    implements UsecaseWithParams<List<HistoryEntity>, GetMyHistoryUsecaseParams> {
  final IHistoryRepository _historyRepository;

  GetMyHistoryUsecase({required IHistoryRepository historyRepository})
      : _historyRepository = historyRepository;

  @override
  Future<Either<Failure, List<HistoryEntity>>> call(GetMyHistoryUsecaseParams params) {
    return _historyRepository.getMyHistory(page: params.page, size: params.size);
  }
}