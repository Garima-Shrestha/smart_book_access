import 'package:flutter/material.dart';
import 'package:lost_n_found/features/auth/presentation/page/signup_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Novella',
      debugShowCheckedModeBanner: false,  // debug banner hatauna
      // home: SplashScreen(),
      home: SignupPage(),
    );
  }
}
