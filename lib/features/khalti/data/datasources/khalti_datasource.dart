import 'package:smart_book_access/features/khalti/data/models/khalti_api_model.dart';

abstract interface class IKhaltiRemoteDataSource {
  Future<KhaltiInitiateResponseApiModel> initiatePayment(KhaltiInitiateRequestApiModel request);
  Future<KhaltiVerifyResponseApiModel> verifyPayment(KhaltiVerifyRequestApiModel request);
}