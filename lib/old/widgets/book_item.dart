// import 'package:flutter/material.dart';
// import 'package:smart_book_access/model/book.dart';
//
// // Book Item contains design for single book
// class BookItem extends StatelessWidget {
//   final Book book;
//   const BookItem({super.key, required this.book});   // here required this.book means you must provide this value when creating the widget or the code won’t run.
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 130,
//       margin: const EdgeInsets.only(right: 15),
//       child: Column(
//         children: [
//           // used card view
//           Card(
//             elevation: 4,
//             margin: EdgeInsets.zero,   // Removes the Card's default external padding/margin to allow for precise spacing control.
//             clipBehavior: Clip.antiAlias,  // It makes the cut edges look cleaner instead of rough. [// Ensures the child content (image) is smoothly clipped to the Card's rounded shape.]
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: Image.asset(
//               book.image,
//               height: 180,
//               width: 130,
//               fit: BoxFit.cover,   // It makes the image fill the space completely.
//             ),
//           ),
//
//           const SizedBox(height: 8),
//           //Book Name
//           Text(
//             book.bookName,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//             maxLines: 1,  // show only one line of text
//             overflow: TextOverflow.ellipsis,  // show "..." when text is too long
//           ),
//
//           // Author Name
//           Text(
//             book.authName,
//             style: TextStyle(color: Colors.grey, fontSize: 12),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           )
//         ],
//       ),
//     );
//   }
// }
