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
// import 'package:flutter/material.dart';
// import 'package:smart_book_access/models/book_library.dart';
// import 'package:smart_book_access/widgets/book_card.dart';
//
// class MylibraryScreen extends StatefulWidget {
//   const MylibraryScreen({super.key});
//
//   @override
//   State<MylibraryScreen> createState() => _MylibraryScreenState();
// }
//
// class _MylibraryScreenState extends State<MylibraryScreen> {
//   // Books List
//   final List<BookLibrary> library = [
//     BookLibrary(
//       bookName: "The Names",
//       authName: "Don DeLillo",
//       image: "assets/images/namesBook.jpg",
//       pages: 339,
//       progress: 0.62,
//       timeOrStatus: '3 days',
//       rentalExpired: false,
//     ),
//     BookLibrary(
//       bookName: "The Design of Book",
//       authName: "Debbie Berne",
//       image: 'assets/images/designBook.jpg',
//       pages: 256,
//       progress: 0.87,
//       timeOrStatus: "Rental Expired",
//       rentalExpired: true,
//     ),
//     BookLibrary(
//       bookName: "Harry Potter",
//       authName: "J.K. Rowling",
//       image: 'assets/images/potterBook.jpg',
//       pages: 336,
//       progress: 1.0,
//       timeOrStatus: "Finished",
//       rentalExpired: false,
//     ),
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 30.0, top: 40.0, bottom: 20.0),
//             child: Text("My Library", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
//           ),
//
//           // List of Books
//           Expanded(
//             child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 itemCount: library.length,
//                 itemBuilder: (context, index) {
//                   return BookCard(book: library[index]);
//                 }
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }