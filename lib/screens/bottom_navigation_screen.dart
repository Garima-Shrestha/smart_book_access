import 'package:flutter/material.dart';
import 'package:smart_book_access/screens/bottom_screen/history_screen.dart';
import 'package:smart_book_access/screens/bottom_screen/home_screen.dart';
import 'package:smart_book_access/screens/bottom_screen/mylibrary_screen.dart';
import 'package:smart_book_access/screens/bottom_screen/profile_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen =[
    const HomeScreen(),
    const MylibraryScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
          items: const[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_add),
              label: 'My Library',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],

        // backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,

        currentIndex: _selectedIndex,
          onTap: (index){
            setState(() {
              _selectedIndex = index;
            });
          },
      ),
    );
  }
}
