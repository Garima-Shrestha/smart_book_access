import 'package:equatable/equatable.dart';

enum ConfirmPaymentStatus {
  initial,
  loading,
  success,
  error,
}

class ConfirmPaymentState extends Equatable {
  final ConfirmPaymentStatus status;
  final String? errorMessage;

  const ConfirmPaymentState({
    this.status = ConfirmPaymentStatus.initial,
    this.errorMessage,
  });

  ConfirmPaymentState copyWith({
    ConfirmPaymentStatus? status,
    String? errorMessage,
  }) {
    return ConfirmPaymentState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}