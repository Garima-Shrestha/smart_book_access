import 'package:json_annotation/json_annotation.dart';
import 'package:smart_book_access/features/confirmPayment/domain/entities/confirm_payment_entity.dart';

part 'confirm_payment_api_model.g.dart';

@JsonSerializable()
class ConfirmPaymentApiModel {
  final String bookId;
  final String userId;
  final String expiresAt;

  ConfirmPaymentApiModel({
    required this.bookId,
    required this.userId,
    required this.expiresAt,
  });


  factory ConfirmPaymentApiModel.fromJson(Map<String, dynamic> json) =>
      _$ConfirmPaymentApiModelFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => {'expiresAt': expiresAt};


  // From Entity
  factory ConfirmPaymentApiModel.fromEntity(RentalEntity entity) {
    return ConfirmPaymentApiModel(
      bookId: entity.bookId,
      userId: entity.userId,
      expiresAt: entity.expiresAt,
    );
  }
}