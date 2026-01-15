import 'package:flutter/material.dart';
import 'package:smart_book_access/app/theme/app_theme.dart';
import 'package:smart_book_access/features/splash/presentation/page/splash_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Novella',
      debugShowCheckedModeBanner: false,  // debug banner hatauna
      theme: getApplicationTheme(),
      home: SplashPage(),
    );
  }
}
