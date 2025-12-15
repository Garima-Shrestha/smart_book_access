import 'package:flutter/material.dart';
import 'package:smart_book_access/screens/splash_screen.dart';
import 'package:smart_book_access/theme/theme_data.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getApplicationTheme(),
      home: SplashScreen(),

      debugShowCheckedModeBanner: false,    // debug banner hatauna
    );
  }
}
