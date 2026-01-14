import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/services/hive/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService().init();

  // shared preferences ko object
  // shared pref = async
  // provider = sync

  // shared Prefs
  final sharedPrefs = await SharedPreferences.getInstance();

  // JIT -> Just in time -> hot reload
  runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
          child: App()));
}
