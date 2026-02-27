import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_book_access/features/khalti/domain/entities/khalti_entity.dart';

part 'khalti_api_model.g.dart';


@JsonSerializable()
class KhaltiInitiateRequestApiModel {
  final String bookId;
  final int amount;
  final String purchase_order_id;
  final String purchase_order_name;

  final KhaltiCustomerInfoApiModel? customer_info;

  KhaltiInitiateRequestApiModel({
    required this.bookId,
    required this.amount,
    required this.purchase_order_id,
    required this.purchase_order_name,
    this.customer_info,
  });

  factory KhaltiInitiateRequestApiModel.fromJson(Map<String, dynamic> json) =>
      _$KhaltiInitiateRequestApiModelFromJson(json);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'bookId': bookId,
      'amount': amount,
      'purchase_order_id': purchase_order_id,
      'purchase_order_name': purchase_order_name,
    };
    if (customer_info != null) {
      map['customer_info'] = customer_info!.toJson();
    }
    return map;
  }

  factory KhaltiInitiateRequestApiModel.fromEntity(KhaltiPaymentEntity entity) {
    return KhaltiInitiateRequestApiModel(
      bookId: entity.bookId,
      amount: entity.amount,
      purchase_order_id: entity.purchaseOrderId,
      purchase_order_name: entity.purchaseOrderName,
      customer_info: (entity.customerName == null &&
          entity.customerEmail == null &&
          entity.customerPhone == null)
          ? null
          : KhaltiCustomerInfoApiModel(
        name: entity.customerName,
        email: entity.customerEmail,
        phone: entity.customerPhone,
      ),
    );
  }
}

@JsonSerializable()
class KhaltiCustomerInfoApiModel {
  final String? name;
  final String? email;
  final String? phone;

  KhaltiCustomerInfoApiModel({
    this.name,
    this.email,
    this.phone,
  });

  factory KhaltiCustomerInfoApiModel.fromJson(Map<String, dynamic> json) =>
      _$KhaltiCustomerInfoApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$KhaltiCustomerInfoApiModelToJson(this);
}

@JsonSerializable()
class KhaltiInitiateResponseApiModel {
  final String pidx;

  @JsonKey(name: 'payment_url')
  final String paymentUrl;

  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  KhaltiInitiateResponseApiModel({
    required this.pidx,
    required this.paymentUrl,
    this.expiresAt,
  });

  factory KhaltiInitiateResponseApiModel.fromJson(Map<String, dynamic> json) =>
      _$KhaltiInitiateResponseApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$KhaltiInitiateResponseApiModelToJson(this);

  KhaltiInitiateResponseEntity toEntity() {
    return KhaltiInitiateResponseEntity(
      pidx: pidx,
      paymentUrl: paymentUrl,
      expiresAt: expiresAt,
    );
  }
}

@JsonSerializable()
class KhaltiVerifyRequestApiModel {
  final String pidx;

  KhaltiVerifyRequestApiModel({required this.pidx});

  factory KhaltiVerifyRequestApiModel.fromJson(Map<String, dynamic> json) =>
      _$KhaltiVerifyRequestApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$KhaltiVerifyRequestApiModelToJson(this);
}

@JsonSerializable()
class KhaltiVerifyResponseApiModel {
  final String status;
  final String? bookAccessId;

  KhaltiVerifyResponseApiModel({
    required this.status,
    this.bookAccessId,
  });

  factory KhaltiVerifyResponseApiModel.fromJson(Map<String, dynamic> json) =>
      _$KhaltiVerifyResponseApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$KhaltiVerifyResponseApiModelToJson(this);

  KhaltiVerifyResponseEntity toEntity() {
    return KhaltiVerifyResponseEntity(
      status: status,
      bookAccessId: bookAccessId,
    );
  }
}