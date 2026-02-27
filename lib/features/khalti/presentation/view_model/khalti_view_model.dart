import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/features/khalti/domain/usecase/initiate_khalti_usecase.dart';
import 'package:smart_book_access/features/khalti/domain/usecase/verify_khalti_usecase.dart';
import 'package:smart_book_access/features/khalti/presentation/state/khalti_state.dart';

final khaltiViewModelProvider = NotifierProvider<KhaltiViewModel, KhaltiState>(
      () => KhaltiViewModel(),
);

class KhaltiViewModel extends Notifier<KhaltiState> {
  late final InitiateKhaltiUsecase _initiateUsecase;
  late final VerifyKhaltiUsecase _verifyUsecase;

  @override
  KhaltiState build() {
    _initiateUsecase = ref.read(initiateKhaltiUsecaseProvider);
    _verifyUsecase = ref.read(verifyKhaltiUsecaseProvider);
    return const KhaltiState();
  }

  Future<void> initiatePayment({
    required String bookId,
    required int amount,
    required String purchaseOrderId,
    required String purchaseOrderName,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
  }) async {
    state = state.copyWith(
      status: KhaltiStatus.initiating,
      errorMessage: null,
      initiateResponse: null,
      verifyResponse: null,
    );

    final params = InitiateKhaltiUsecaseParams(
      bookId: bookId,
      amount: amount,
      purchaseOrderId: purchaseOrderId,
      purchaseOrderName: purchaseOrderName,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
    );

    final result = await _initiateUsecase.call(params);

    result.fold(
          (failure) {
        state = state.copyWith(
          status: KhaltiStatus.error,
          errorMessage: failure.message,
        );
      },
          (response) {
        state = state.copyWith(
          status: KhaltiStatus.initiated,
          initiateResponse: response,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> verifyPayment({required String pidx}) async {
    state = state.copyWith(
      status: KhaltiStatus.verifying,
      errorMessage: null,
      verifyResponse: null,
    );

    final params = VerifyKhaltiUsecaseParams(pidx: pidx);
    final result = await _verifyUsecase.call(params);

    result.fold(
          (failure) {
        state = state.copyWith(
          status: KhaltiStatus.error,
          errorMessage: failure.message,
        );
      },
          (response) {
        if (response.isCompleted) {
          state = state.copyWith(
            status: KhaltiStatus.completed,
            verifyResponse: response,
            errorMessage: null,
          );
        } else {
          state = state.copyWith(
            status: KhaltiStatus.failed,
            verifyResponse: response,
            errorMessage: "Payment status: ${response.status}",
          );
        }
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}