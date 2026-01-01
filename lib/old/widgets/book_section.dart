// import 'package:flutter/material.dart';
// import 'package:smart_book_access/model/book.dart';
// import 'package:smart_book_access/widgets/book_item.dart';
//
// // Book section contains design for how multiple books should appear(the horizontal scrollable list) along with title and see all button
// class BookSection extends StatelessWidget {
//   final String title;
//   final List<Book> books;
//   const BookSection({
//     super.key,
//     required this.title,
//     required this.books,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Title and See All Row
//         Padding(
//             padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0, bottom: 15.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//               ),
//               TextButton(
//                 onPressed: () {},
//                 child: const Text(
//                   "See all",
//                   style: TextStyle(fontSize: 16, color: Color(0xFF1A68EE)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         // Horizontal Book List
//         SizedBox(
//           height: 250,  // for the cover and text below
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: books.length,
//             padding: EdgeInsets.only(left: 30.0),
//             itemBuilder: (context, index) {
//               return BookItem(book: books[index]);   // This uses the BookItem widget
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
