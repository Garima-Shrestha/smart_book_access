// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'khalti_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KhaltiInitiateRequestApiModel _$KhaltiInitiateRequestApiModelFromJson(
        Map<String, dynamic> json) =>
    KhaltiInitiateRequestApiModel(
      bookId: json['bookId'] as String,
      amount: (json['amount'] as num).toInt(),
      purchase_order_id: json['purchase_order_id'] as String,
      purchase_order_name: json['purchase_order_name'] as String,
      customer_info: json['customer_info'] == null
          ? null
          : KhaltiCustomerInfoApiModel.fromJson(
              json['customer_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KhaltiInitiateRequestApiModelToJson(
        KhaltiInitiateRequestApiModel instance) =>
    <String, dynamic>{
      'bookId': instance.bookId,
      'amount': instance.amount,
      'purchase_order_id': instance.purchase_order_id,
      'purchase_order_name': instance.purchase_order_name,
      'customer_info': instance.customer_info,
    };

KhaltiCustomerInfoApiModel _$KhaltiCustomerInfoApiModelFromJson(
        Map<String, dynamic> json) =>
    KhaltiCustomerInfoApiModel(
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$KhaltiCustomerInfoApiModelToJson(
        KhaltiCustomerInfoApiModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
    };

KhaltiInitiateResponseApiModel _$KhaltiInitiateResponseApiModelFromJson(
        Map<String, dynamic> json) =>
    KhaltiInitiateResponseApiModel(
      pidx: json['pidx'] as String,
      paymentUrl: json['payment_url'] as String,
      expiresAt: json['expires_at'] as String?,
    );

Map<String, dynamic> _$KhaltiInitiateResponseApiModelToJson(
        KhaltiInitiateResponseApiModel instance) =>
    <String, dynamic>{
      'pidx': instance.pidx,
      'payment_url': instance.paymentUrl,
      'expires_at': instance.expiresAt,
    };

KhaltiVerifyRequestApiModel _$KhaltiVerifyRequestApiModelFromJson(
        Map<String, dynamic> json) =>
    KhaltiVerifyRequestApiModel(
      pidx: json['pidx'] as String,
    );

Map<String, dynamic> _$KhaltiVerifyRequestApiModelToJson(
        KhaltiVerifyRequestApiModel instance) =>
    <String, dynamic>{
      'pidx': instance.pidx,
    };

KhaltiVerifyResponseApiModel _$KhaltiVerifyResponseApiModelFromJson(
        Map<String, dynamic> json) =>
    KhaltiVerifyResponseApiModel(
      status: json['status'] as String,
      bookAccessId: json['bookAccessId'] as String?,
    );

Map<String, dynamic> _$KhaltiVerifyResponseApiModelToJson(
        KhaltiVerifyResponseApiModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'bookAccessId': instance.bookAccessId,
    };
