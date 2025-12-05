import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_book_access/screens/login_screen.dart';
import 'package:smart_book_access/screens/registration_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  // Koho font style use garna
  TextStyle getKohoStyle({required FontWeight weight, required double size}) {
    return GoogleFonts.koHo(
      fontWeight: weight,
      fontSize: size,
      color: Colors.black,
      height: 1.2,
    );
  }


  // Dot indicator widget
  Widget _buildDot(int index) {   // returns a single widgets
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4), // Adds small horizontal spacing between each dot.
      width: _currentPage == index ? 12 : 8,  // The Dot in the current page will have width 12 while other in active pages will be 8.
      height: _currentPage == index? 12 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Color(0xFF00354B) : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }


  // Each onboarding page
  List<Widget> _pages() => [   // returns list of strings
    // Screen 1: Discover Books
    Container(
      color:  Color(0xFFBFD6FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/onboarding1.jpg', height: 300),
          SizedBox(height: 40),
          Text("Explore Thousands of Books",
            style: getKohoStyle(weight: FontWeight.bold, size: 28),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            "Find your next favorite book in any genre",
            style: getKohoStyle(weight: FontWeight.normal, size: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),

    // Screen 2: Benefits
    Container(
      color:  Color(0xFFBFD6FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/onboarding2.png', height: 300),
          SizedBox(height: 40),
          Text(
            "Save & Enjoy More",
            style: getKohoStyle(weight: FontWeight.bold, size: 28),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            "Get exclusive deals and track your personal library",
            style: getKohoStyle(weight: FontWeight.normal, size: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),

    // Screen 3: Welcome page
    Container(
      color: Color(0xFFBFD6FF),
      child: SingleChildScrollView(
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
    )
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFBFD6FF),
        appBar: AppBar(toolbarHeight: 0.0, backgroundColor: Color(0xFFBFD6FF),),  // Reducing the height of the AppBar's toolbar. Default ma ~56.0 hunxa. 0.0 le height remove gardinxa.
        body: Stack(   // allows you to layer or overlap multiple widgets on top of one another
          alignment: Alignment.bottomCenter,   // to keep the dots to bottomcenter
          children: [
            PageView( // easily swipe horizontally between different screens,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;  // updates the current index.
                });
              },
              children: _pages(),
            ),

            // SKIP BUTTON (show only on page 0 and 1)
            if (_currentPage < 2)
              Positioned(
                top: 40,   // to keep skip in top
                right: 20,  // to keep skip in right
                child: GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      2,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,    // makes the animation start slowly, speed up in the middle, and slow down again at the end for a smooth effect.
                    );
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF00354B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),


            // Dots indicator
            Positioned(   // Places a widget at an exact position inside a Stack.
                bottom: 20,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages().length, (index) => _buildDot(index)),   // Creates a list dynamically. Here,
                )
            )
          ],
        )
    );
  }
}
