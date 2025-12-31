import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String authId;
  final String name;
  final String email;
  final String phone;
  // final String? token;

  const AuthEntity({
    required this.authId,
    required this.name,
    required this.email,
    required this.phone,
    // this.token
});

  @override
  // List<Object?> get props => [authId, name, email, phone, token];
  List<Object?> get props => [authId, name, email, phone];
}