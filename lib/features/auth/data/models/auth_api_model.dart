import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';

// part 'auth_api_model.g.dart';

class AuthApiModel {
  final String? id;
  final String username;
  final String email;
  final String countryCode;
  final String phone;
  final String? password;
  final String? imageUrl;

  AuthApiModel({
    this.id,
    required this.username,
    required this.email,
    required this.countryCode,
    required this.phone,
    this.password,
    this.imageUrl,
});

  // toJSON
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "countryCode": countryCode,
      "phone": phone,
      "password": password,
      "imageUrl": imageUrl,
    };
  }

  // fromJson
  factory AuthApiModel.fromJson(Map<String, dynamic> json){
    return AuthApiModel(
        id: json['_id'] as String?,
        username: json['username'] as String,
        email: json['email'] as String,
        countryCode: json['countryCode'] as String,
        phone: json['phone'] as String? ?? '',
        password: json['password'] as String?,
        // imageUrl: json['imageUrl'] as String?,
        imageUrl: (json['imageUrl'] ?? json['image']) as String?,
    );
  }

  // toEntity
  AuthEntity toEntity() {
    return AuthEntity(
        authId: id,
        username: username,
        email: email,
        countryCode: countryCode,
        phone: phone,
        password: password,
        imageUrl: imageUrl,
    );
  }

  // fromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
        id: entity.authId,
        username: entity.username,
        email: entity.email,
        countryCode: entity.countryCode,
        phone: entity.phone,
        password: entity.password,
        imageUrl: entity.imageUrl,
    );
  }

  // toEntityList
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}