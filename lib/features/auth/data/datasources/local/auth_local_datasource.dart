import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/services/hive/hive_service.dart';
import 'package:smart_book_access/core/services/storage/user_session_service.dart';
import 'package:smart_book_access/features/auth/data/datasources/auth_datasource.dart';
import 'package:smart_book_access/features/auth/data/models/auth_hive_model.dart';


final authLocalDataSourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthLocalDataSource{
  // Dependency injection
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
        _userSessionService = userSessionService;


  @override
  Future<AuthHiveModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<bool> isEmailExists(String email) async {
    try{
      final exists = await _hiveService.isEmailExists(email);
      return Future.value(exists);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = await _hiveService.login(email, password);
      // user ko details lai shared prefs ma save garne
      if (user != null && user.authId != null) {
        await _userSessionService.saveUserSession(
          userId: user.authId!,
          username: user.username,
          email: user.email,
          countryCode: user.countryCode,
          phoneNumber: user.phone,
        );
      }
      return Future.value(user);
    } catch (e) {
      return Future.value(null);
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _userSessionService.clearUserSession();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> register(AuthHiveModel model) async {
    try{
      await _hiveService.registerUser(model);
      return Future.value(true);
    }catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> updateProfile(AuthHiveModel model) async {
    try {
      await _hiveService.updateUser(model);

      if (model.authId != null) {
        await _userSessionService.saveUserSession(
          userId: model.authId!,
          username: model.username,
          email: model.email,
          countryCode: model.countryCode,
          phoneNumber: model.phone,
          imageUrl: model.imageUrl,
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}