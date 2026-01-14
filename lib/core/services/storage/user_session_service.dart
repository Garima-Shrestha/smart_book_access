import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Shared Prefs Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});


// provider
final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  return UserSessionService(prefs: ref.read(sharedPreferencesProvider));
});

class UserSessionService {
  final SharedPreferences _prefs;

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  // Keys for storing data
  static const String _keysIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhoneNumber = 'user_phone_number';

  // Store user session data
  Future<void> saveUserSession({
    required String userId,
    required String name,
    required String email,
    required String phoneNumber,
  }) async{
      await _prefs.setBool(_keysIsLoggedIn, true);
      await _prefs.setString(_keyUserId, userId);
      await _prefs.setString(_keyUserName, name);
      await _prefs.setString(_keyUserEmail, email);
      if (phoneNumber != null) {
        await _prefs.setString(_keyUserPhoneNumber, phoneNumber);
      }
  }

  // Clear User Sessions Data
  Future<void> clearUserSession() async {
    await _prefs.remove(_keysIsLoggedIn);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserName);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserPhoneNumber);
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _prefs.getBool(_keysIsLoggedIn) ?? false;
  }

  // Get current user ID
  String? getCurrentUserId() {
    return _prefs.getString(_keyUserId);
  }

  // Get current user name
  String? getCurrentUserName() {
    return _prefs.getString(_keyUserName);
  }

  // Get current user email
  String? getCurrentUserEmail() {
    return _prefs.getString(_keyUserEmail);
  }

  // Get current user phone number
  String? getCurrentUserPhoneNumber() {
    return _prefs.getString(_keyUserPhoneNumber);
  }

}