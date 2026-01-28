import 'package:hive/hive.dart';
import 'package:smart_book_access/core/constants/hive_table_constant.dart';
import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';
import 'package:uuid/uuid.dart';


part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String countryCode;
  @HiveField(4)
  final String phone;
  @HiveField(5)
  final String? password;
  @HiveField(6)
  final String? imageUrl;


  // Constructor
  AuthHiveModel({
    String? authId,
    required this.username,
    required this.email,
    required this.countryCode,
    required this.phone,
    this.password,
    this.imageUrl,
}) : authId = authId ?? Uuid().v4();


  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity){
    return AuthHiveModel(
        authId: entity.authId,
        username: entity.username,
        email: entity.email,
        countryCode: entity.countryCode,
        phone: entity.phone,
        password: entity.password,
        imageUrl: entity.imageUrl,
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
        authId: authId,
        username: username,
        email: email,
        countryCode: countryCode,
        phone: phone,
        password: password,
        imageUrl: imageUrl,
    );
  }

  // ToEntityList
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models){
    return models.map((model) => model.toEntity()).toList();
  }
}