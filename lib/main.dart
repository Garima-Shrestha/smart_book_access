import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';

import 'app/app.dart';
import 'core/services/hive/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService().init();

  // Clear auth data (for testing splash page)
  final authBox = Hive.box<AuthHiveModel>(HiveTableConstant.authTable);
  await authBox.clear(); // This removes all previously logged-in users

  // JIT -> Just in time -> hot reload
  runApp(const ProviderScope(child: App()));
}
