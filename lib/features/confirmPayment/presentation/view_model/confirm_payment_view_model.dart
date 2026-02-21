import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/features/confirmPayment/domain/entities/confirm_payment_entity.dart';
import 'package:smart_book_access/features/confirmPayment/domain/usecase/rent_book_usecase.dart';
import 'package:smart_book_access/features/confirmPayment/presentation/state/confirm_payment_state.dart';

final confirmPaymentViewModelProvider =
NotifierProvider<ConfirmPaymentViewModel, ConfirmPaymentState>(
      () => ConfirmPaymentViewModel(),
);

class ConfirmPaymentViewModel extends Notifier<ConfirmPaymentState> {
  late final RentBookUsecase _rentBookUsecase;

  @override
  ConfirmPaymentState build() {
    _rentBookUsecase = ref.read(rentBookUsecaseProvider);
    return const ConfirmPaymentState();
  }

  Future<void> rentBook(RentalEntity rental) async {
    state = state.copyWith(status: ConfirmPaymentStatus.loading);

    final result = await _rentBookUsecase.call(rental);

    result.fold(
          (failure) {
        state = state.copyWith(
          status: ConfirmPaymentStatus.error,
          errorMessage: failure.message,
        );
      },
          (success) {
        state = state.copyWith(
          status: ConfirmPaymentStatus.success,
          errorMessage: null,
        );
      },
    );
  }
}