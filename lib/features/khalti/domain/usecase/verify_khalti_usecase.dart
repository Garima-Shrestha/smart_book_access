import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/khalti/data/repositories/khalti_repository.dart';
import 'package:smart_book_access/features/khalti/domain/entities/khalti_entity.dart';
import 'package:smart_book_access/features/khalti/domain/repositories/khalti_repository.dart';

final verifyKhaltiUsecaseProvider = Provider<VerifyKhaltiUsecase>((ref) {
  return VerifyKhaltiUsecase(
    khaltiRepository: ref.read(khaltiRepositoryProvider),
  );
});

class VerifyKhaltiUsecaseParams extends Equatable {
  final String pidx;

  const VerifyKhaltiUsecaseParams({required this.pidx});

  @override
  List<Object?> get props => [pidx];
}

class VerifyKhaltiUsecase
    implements UsecaseWithParams<KhaltiVerifyResponseEntity, VerifyKhaltiUsecaseParams> {
  final IKhaltiRepository _khaltiRepository;

  VerifyKhaltiUsecase({required IKhaltiRepository khaltiRepository})
      : _khaltiRepository = khaltiRepository;

  @override
  Future<Either<Failure, KhaltiVerifyResponseEntity>> call(
      VerifyKhaltiUsecaseParams params,
      ) {
    return _khaltiRepository.verifyPayment(params.pidx);
  }
}