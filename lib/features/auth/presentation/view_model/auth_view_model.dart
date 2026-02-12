import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/services/storage/user_session_service.dart';
import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';
import 'package:smart_book_access/features/auth/domain/usecase/change_password_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/forgot_password_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/login_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/logout_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/register_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/reset_password_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/update_profile_usecase.dart';
import 'package:smart_book_access/features/auth/presentation/state/auth_state.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
    () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState>{
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final UpdateProfileUsecase _updateProfileUsecase;
  late final ChangePasswordUsecase _changePasswordUsecase;
  late final ForgotPasswordUsecase _forgotPasswordUsecase;
  late final ResetPasswordUsecase _resetPasswordUsecase;


  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    _changePasswordUsecase = ref.read(changePasswordUsecaseProvider);
    _forgotPasswordUsecase = ref.read(forgotPasswordUsecaseProvider);
    _resetPasswordUsecase = ref.read(resetPasswordUsecaseProvider);
    Future.microtask(() => _init());
    return AuthState();
  }

  Future<void> _init() async {
    final sessionService = ref.read(userSessionServiceProvider);

    if (sessionService.isLoggedIn()) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        authEntity: AuthEntity(
          authId: sessionService.getCurrentUserId() ?? '',
          username: sessionService.getCurrentUserName() ?? '',
          email: sessionService.getCurrentUserEmail() ?? '',
          phone: sessionService.getCurrentUserPhoneNumber() ?? '',
          countryCode: sessionService.getCurrentUserCountryCode() ?? '',
          imageUrl: sessionService.getCurrentUserImageUrl(),
        ),
      );
    }
  }

  Future<void> register ({
    required String username,
    required String email,
    required String countryCode,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    // wait for 2 seconds
    await Future.delayed(Duration(seconds: 2));

    final params = RegisterUsecaseParams(
        username: username,
        email: email,
        countryCode: countryCode,
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
    // wait for 2 seconds
    await Future.delayed(Duration(seconds: 2));

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


  // logout
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _logoutUsecase();

    result.fold(
          (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
          (success) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        authEntity: null,
      ),
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }


  // Update Profile
  Future<void> updateProfile({
    required String username,
    required String email,
    required String countryCode,
    required String phone,
    File? imageUrl,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final params = UpdateProfileUsecaseParams(
      username: username,
      email: email,
      countryCode: countryCode,
      phone: phone,
      imageUrl: imageUrl,
    );

    final result = await _updateProfileUsecase.call(params);

    result.fold(
          (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
          (success) async {
            final sessionService = ref.read(userSessionServiceProvider);

            await sessionService.saveUserSession(
              userId: state.authEntity?.authId ?? '',
              username: username,
              email: email,
              countryCode: countryCode,
              phoneNumber: phone,
              // If a new image was picked, save its local path, otherwise keep the old one
              imageUrl: imageUrl?.path ?? state.authEntity?.imageUrl,
            );

            state = state.copyWith(
              status: AuthStatus.updated,
              errorMessage: null,
              authEntity: AuthEntity(
                authId: state.authEntity?.authId, // Keep existing ID
                username: username,
                email: email,
                phone: phone,
                countryCode: countryCode,
                // Keep existing image or handle new one if needed
                // imageUrl: state.authEntity?.imageUrl,

                imageUrl: imageUrl?.path ?? state.authEntity?.imageUrl,
              ),
            );
      },
    );
  }

  // Change Password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final params = ChangePasswordParams(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    final result = await _changePasswordUsecase.call(params);

    result.fold(
          (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
          (success) {
        state = state.copyWith(
          status: AuthStatus.passwordChanged,
          errorMessage: null,
        );
      },
    );
  }

  // Forgot Password
  Future<void> forgotPassword(String email) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _forgotPasswordUsecase.call(email);

    result.fold(
          (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
          (success) => state = state.copyWith(
        status: AuthStatus.resetLinkSent,
        errorMessage: null,
      ),
    );
  }

  // Reset Password
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final params = ResetPasswordParams(token: token, password: password);
    final result = await _resetPasswordUsecase.call(params);

    result.fold(
          (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
          (success) => state = state.copyWith(
        status: AuthStatus.passwordReset,
        errorMessage: null,
      ),
    );
  }
}