import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? password;

  AuthApiModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.password,
});

  // toJSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
    };
  }

  // fromJson
  factory AuthApiModel.fromJson(Map<String, dynamic> json){
    return AuthApiModel(
        id: json['_id'] as String?,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String? ?? '',
        password: json['password'] as String?,
    );
  }

  // toEntity
  AuthEntity toEntity() {
    return AuthEntity(
        authId: id,
        name: name,
        email: email,
        phone: phone,
        password: password,
    );
  }

  // fromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
        name: entity.name,
        email: entity.email,
        phone: entity.phone,
        password: entity.password,
    );
  }

  // toEntityList
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}