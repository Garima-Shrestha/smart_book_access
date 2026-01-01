import 'package:equatable/equatable.dart';

enum SplashStatus { initial, loading, success, error }

class SplashState extends Equatable {
  final SplashStatus status;
  final bool? isLoggedIn; // true if user is logged in, false otherwise
  final String? errorMessage;

  const SplashState ({
    this.status = SplashStatus.initial,
    this.isLoggedIn,
    this.errorMessage,
  });

  SplashState copyWith({
    SplashStatus? status,
    bool? isLoggedIn,
    String? errorMessage,
  }) {
    return SplashState(
      status: status ?? this.status,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>[status, isLoggedIn, errorMessage];
}