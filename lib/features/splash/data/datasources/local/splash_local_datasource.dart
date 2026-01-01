import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/services/hive/hive_service.dart';

final splashLocalDatasourceProvider = Provider<SplashLocalDataSource>((ref) {
  return SplashLocalDataSource(hiveService: ref.read(hiveServiceProvider));
});

class SplashLocalDataSource{
  final HiveService _hiveService;

  SplashLocalDataSource({required HiveService hiveService})
      : _hiveService = hiveService;

  // Checks if a user is already logged in
  Future<bool> isUserLoggedIn() async {
    try {
      final loggedIn = await _hiveService.isUserLoggedIn();
      // return Future.value(true);
      return loggedIn;
    } catch (e) {
      return Future.value(false);
    }
  }
}