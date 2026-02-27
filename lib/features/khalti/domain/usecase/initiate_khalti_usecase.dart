import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/usecase/app_usecase.dart';
import 'package:smart_book_access/features/khalti/data/repositories/khalti_repository.dart';
import 'package:smart_book_access/features/khalti/domain/entities/khalti_entity.dart';
import 'package:smart_book_access/features/khalti/domain/repositories/khalti_repository.dart';

final initiateKhaltiUsecaseProvider = Provider<InitiateKhaltiUsecase>((ref) {
  return InitiateKhaltiUsecase(
    khaltiRepository: ref.read(khaltiRepositoryProvider),
  );
});

class InitiateKhaltiUsecaseParams extends Equatable {
  final String bookId;
  final int amount; // paisa
  final String purchaseOrderId;
  final String purchaseOrderName;

  // optional customer info
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;

  const InitiateKhaltiUsecaseParams({
    required this.bookId,
    required this.amount,
    required this.purchaseOrderId,
    required this.purchaseOrderName,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
  });

  @override
  List<Object?> get props => [
    bookId,
    amount,
    purchaseOrderId,
    purchaseOrderName,
    customerName,
    customerEmail,
    customerPhone,
  ];
}

class InitiateKhaltiUsecase
    implements UsecaseWithParams<KhaltiInitiateResponseEntity, InitiateKhaltiUsecaseParams> {
  final IKhaltiRepository _khaltiRepository;

  InitiateKhaltiUsecase({required IKhaltiRepository khaltiRepository})
      : _khaltiRepository = khaltiRepository;

  @override
  Future<Either<Failure, KhaltiInitiateResponseEntity>> call(
      InitiateKhaltiUsecaseParams params,
      ) {
    final entity = KhaltiPaymentEntity(
      bookId: params.bookId,
      amount: params.amount,
      purchaseOrderId: params.purchaseOrderId,
      purchaseOrderName: params.purchaseOrderName,
      customerName: params.customerName,
      customerEmail: params.customerEmail,
      customerPhone: params.customerPhone,
    );

    return _khaltiRepository.initiatePayment(entity);
  }
}