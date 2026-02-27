import 'package:equatable/equatable.dart';
import 'package:smart_book_access/features/khalti/domain/entities/khalti_entity.dart';

enum KhaltiStatus {
  initial,
  initiating,
  initiated,
  verifying,
  completed,
  failed,
  error,
}

class KhaltiState extends Equatable {
  final KhaltiStatus status;
  final KhaltiInitiateResponseEntity? initiateResponse;
  final KhaltiVerifyResponseEntity? verifyResponse;
  final String? errorMessage;

  const KhaltiState({
    this.status = KhaltiStatus.initial,
    this.initiateResponse,
    this.verifyResponse,
    this.errorMessage,
  });

  KhaltiState copyWith({
    KhaltiStatus? status,
    KhaltiInitiateResponseEntity? initiateResponse,
    KhaltiVerifyResponseEntity? verifyResponse,
    String? errorMessage,
  }) {
    return KhaltiState(
      status: status ?? this.status,
      initiateResponse: initiateResponse ?? this.initiateResponse,
      verifyResponse: verifyResponse ?? this.verifyResponse,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    initiateResponse,
    verifyResponse,
    errorMessage,
  ];
}