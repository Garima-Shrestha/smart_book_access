import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/confirmPayment/data/repositories/confirm_payment_repository.dart';
import 'package:smart_book_access/features/confirmPayment/domain/entities/confirm_payment_entity.dart';
import 'package:smart_book_access/features/confirmPayment/domain/repositories/confirm_payment_repository.dart';

final rentBookUsecaseProvider = Provider<RentBookUsecase>((ref) {
  return RentBookUsecase(
    repository: ref.read(confirmPaymentRepositoryProvider),
  );
});

class RentBookUsecase implements UsecaseWithParams<bool, RentalEntity> {
  final IConfirmPaymentRepository _repository;

  RentBookUsecase({required IConfirmPaymentRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(RentalEntity params) {
    return _repository.rentBook(params);
  }
}