import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:uuid/uuid.dart';


part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String phone;
  @HiveField(4)
  final String? password;


  // Constructor
  AuthHiveModel({
    String? authId,
    required this.name,
    required this.email,
    required this.phone,
    this.password,
}) : authId = authId ?? Uuid().v4();


  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity){
    return AuthHiveModel(
        authId: entity.authId,
        name: entity.name,
        email: entity.email,
        phone: entity.phone,
        password: entity.password,
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
        authId: authId,
        name: name,
        email: email,
        phone: phone,
        password: password,
    );
  }

  // ToEntityList
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models){
    return models.map((model) => model.toEntity()).toList();
  }
}