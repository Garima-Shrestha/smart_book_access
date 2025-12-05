import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_book_access/screens/login_screen.dart';
import 'package:smart_book_access/screens/registration_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Koho font style use garna
  TextStyle getKohoStyle({required FontWeight weight, required double size}) {
    return GoogleFonts.koHo(
      fontWeight: weight,
      fontSize: size,
      color: Colors.black,
      height: 1.2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBFD6FF),
      appBar: AppBar(toolbarHeight: 0.0, backgroundColor: Color(0xFFBFD6FF),),  // Reducing the height of the AppBar's toolbar. Default ma ~56.0 hunxa. 0.0 le height remove gardinxa.
       body: SingleChildScrollView(
         child: Column(
             children: [
            // Image
            Image.asset('assets/images/welcome.png'),

            // Texts
            SizedBox(height: 20),
            RichText(text: TextSpan(
              text: 'Discover, Enjoy ',
                style: getKohoStyle(weight: FontWeight.bold, size: 30),
                children: [
                  TextSpan(
                      text: 'and ',
                      style: getKohoStyle(weight: FontWeight.normal, size: 30),
                  ),
                  TextSpan(
                    text: '\nSave ',
                    style: getKohoStyle(weight: FontWeight.bold, size: 30),
                  ),
                  TextSpan(
                    text: 'with every book',
                    style: getKohoStyle(weight: FontWeight.normal, size: 30),
                  ),
                ]
              ),
            ),

            // Sign up button
            SizedBox(height: 48),
            SizedBox(
              height: 56,
              width: 265,
              child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const RegistrationScreen())
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00354B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )
                  ),
                  child: Text("Sign up", style: TextStyle(fontSize: 24, color: Colors.white),)
              ),
            ),

            // Login button
            SizedBox(height: 13),
            // ElevatedButton(onPressed: (){
            //   Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const LoginScreen()),
            //   );
            // },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.transparent,
            //     elevation: 0, // remove shadow
            //   ),
           GestureDetector(
             onTap: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const LoginScreen()),
               );
               },
             child: Text('Login',
               style: TextStyle(
                   fontSize: 25,
                   color: Color(0xFF555555),
                   fontWeight: FontWeight.bold
               ),
             ),
           ),
          ]
         ),
       ),
    );
  }
}
