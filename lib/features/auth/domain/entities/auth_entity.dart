import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String username;
  final String email;
  final String countryCode;
  final String phone;
  final String? password;
  final String? imageUrl;
  // final String? token;

  const AuthEntity({
    this.authId,
    required this.username,
    required this.email,
    required this.countryCode,
    required this.phone,
    this.password,
    this.imageUrl
    // this.token
});

  @override
  // List<Object?> get props => [authId, name, email, phone, token];
  List<Object?> get props => [authId, username, email, countryCode, phone, password, imageUrl];
}