import 'package:flutter/material.dart';

ThemeData getApplicationTheme(){
  return ThemeData(
      fontFamily: 'Inter',
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
      )
  );
}