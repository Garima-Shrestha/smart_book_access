// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_payment_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmPaymentApiModel _$ConfirmPaymentApiModelFromJson(
        Map<String, dynamic> json) =>
    ConfirmPaymentApiModel(
      bookId: json['bookId'] as String,
      userId: json['userId'] as String,
      expiresAt: json['expiresAt'] as String,
    );

Map<String, dynamic> _$ConfirmPaymentApiModelToJson(
        ConfirmPaymentApiModel instance) =>
    <String, dynamic>{
      'bookId': instance.bookId,
      'userId': instance.userId,
      'expiresAt': instance.expiresAt,
    };
