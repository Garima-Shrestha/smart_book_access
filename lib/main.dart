import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/services/hive/hive_service.dart';

void main() async {
  await HiveService().init();

  // JIT -> Just in time -> hot reload
  runApp(const ProviderScope(child: App()));
}
