import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/features/auth/domain/usecase/login_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecase/register_usecase.dart';
import 'package:lost_n_found/features/auth/presentation/state/auth_state.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
    () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState>{
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    return AuthState();
  }

  Future<void> register ({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    // wait for 2 seconds
    await Future.delayed(Duration(seconds: 2));

    final params = RegisterUsecaseParams(
        name: name,
        email: email,
        phone: phone,
        password: password
    );
    final result = await _registerUsecase.call(params);

    result.fold((failure) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      );
    }, (isRegisterd) {
        state = state.copyWith(status: AuthStatus.registered);
      }
    );
  }


  // Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = LoginUsecaseParams(email: email, password: password);
    final result = await _loginUsecase(params);

    result.fold(
        (failure) {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          );
        },
        (authEntity) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            authEntity: authEntity,
          );
        },
    );
  }
}