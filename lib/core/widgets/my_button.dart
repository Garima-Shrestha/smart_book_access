import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.fontSize = 18.0, // this will be default size of text for button
    this.isLoading = false,
  });

  // callback
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final double fontSize;
  final bool isLoading;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Color(0xFF00354B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            )
        ),
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
        )
            : Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,  // here by keeping this we can change the fontsize if needed, if we want to keep 24 instead of 18 then we can do it for that particular page
          ),
        ),
    );
  }
}
