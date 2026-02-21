import 'package:dartz/dartz.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/confirmPayment/domain/entities/confirm_payment_entity.dart';

abstract interface class IConfirmPaymentRepository {
  Future<Either<Failure, bool>> rentBook(RentalEntity rental);
}