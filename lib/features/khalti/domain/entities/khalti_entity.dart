import 'package:equatable/equatable.dart';

class KhaltiPaymentEntity extends Equatable {
  final String bookId;
  final int amount;
  final String purchaseOrderId;
  final String purchaseOrderName;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;

  const KhaltiPaymentEntity({
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

class KhaltiInitiateResponseEntity extends Equatable {
  final String pidx;
  final String paymentUrl;
  final String? expiresAt;

  const KhaltiInitiateResponseEntity({
    required this.pidx,
    required this.paymentUrl,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [pidx, paymentUrl, expiresAt];
}

class KhaltiVerifyResponseEntity extends Equatable {
  final String status;
  final String? bookAccessId;

  const KhaltiVerifyResponseEntity({
    required this.status,
    this.bookAccessId,
  });

  bool get isCompleted => status == "Completed";

  @override
  List<Object?> get props => [status, bookAccessId];
}