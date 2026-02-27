import 'package:dartz/dartz.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/khalti/domain/entities/khalti_entity.dart';

abstract interface class IKhaltiRepository {
  Future<Either<Failure, KhaltiInitiateResponseEntity>> initiatePayment(KhaltiPaymentEntity payment,);
  Future<Either<Failure, KhaltiVerifyResponseEntity>> verifyPayment(String pidx,);
}