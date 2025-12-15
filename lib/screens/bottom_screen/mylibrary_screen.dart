import 'package:flutter/material.dart';

class MylibraryScreen extends StatefulWidget {
  const MylibraryScreen({super.key});

  @override
  State<MylibraryScreen> createState() => _MylibraryScreenState();
}

class _MylibraryScreenState extends State<MylibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 40.0, bottom: 20.0),
            child: Text("My Library", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
        ],
      ),
    );
  }
}