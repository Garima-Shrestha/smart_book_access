import 'package:smart_book_access/features/confirmPayment/data/models/confirm_payment_api_model.dart';

abstract interface class IConfirmPaymentRemoteDataSource {
  Future<bool> rentBook(ConfirmPaymentApiModel rental);
}