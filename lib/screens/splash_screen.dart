import 'package:flutter/material.dart';
import 'package:smart_book_access/screens/welcome_screen.dart';
import 'dart:async'; // for timer


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), (){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => WelcomeScreen())  // pushReplacement use garda, user le back garda it won't go back to splash page. But when we use push, user le back garda we go back.
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBFD6FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            // Image.asset('assets/images/splashLogo1.png'),
            // Image.asset('assets/images/splashLogo2.png'),
          ],
        ),
      ),
    );
  }
}
