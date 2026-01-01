// import 'package:flutter/material.dart';
// import 'package:smart_book_access/models/book_library.dart';
//
// class BookCard extends StatelessWidget {
//   final BookLibrary book;
//
//   const BookCard({super.key, required this.book});
//
//   @override
//   Widget build(BuildContext context) {
//     String getProgressPercentage(){   // To get the current progress percentage for display
//       int percentage = (book.progress * 100).toInt();
//       return '$percentage%';
//     }
//
//     return Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//         child: Card(
//           color: Colors.blue.withOpacity(0.12), // Light blue background  [here, 12% opaque, 88% transparent]
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15.0),
//             ),
//           margin: EdgeInsets.zero, // Remove default Card margin
//
//           child: Padding(
//             padding: EdgeInsets.only(left: 12.0, top: 12.0, right: 20.0, bottom: 9.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Book Cover Image
//                 SizedBox(
//                   height: 140,
//                   width: 90,
//                   child: Card(
//                     elevation: 2,
//                     clipBehavior: Clip.antiAlias, // Ensures the image is clipped to the card's shape
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     margin: EdgeInsets.zero,
//                     child: Image.asset(
//                       book.image,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 35.0),  // book ko details lai aali side ma lyauna
//
//                 // Book Details
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Book Name
//                       Text(
//                         book.bookName,
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       // Author
//                       Text(
//                         book.authName,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.black.withOpacity(0.7),
//                         ),
//                       ),
//                       const SizedBox(height: 10.0),
//
//                       // Pages
//                       Text(
//                         '${book.pages} pages',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.black.withOpacity(0.7),
//                         ),
//                       ),
//                       const SizedBox(height: 10.0),
//
//
//                       // Progress Bar and Status
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (book.progress < 1.0) // Only show progress bar if not finished
//                             LinearProgressIndicator(   // horizontal progress bar widget
//                               value: book.progress,
//                               backgroundColor: Colors.blue.withOpacity(0.2),
//                               valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),  // The filled part of the progress bar should always be blue, no animation, just solid blue.
//                               minHeight: 4,  // thickness of the progress bar
//                             ),
//                           SizedBox(height: 5.0),
//
//                           // Progress Percentage
//                           Text(
//                             book.progress < 1.0 ? 'Progress: ${getProgressPercentage()}' : 'Progress: 100%',
//                             style: const TextStyle(
//                               fontSize: 15.5,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 5.0),
//
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               // Time or Status
//                               Text(
//                                 book.timeOrStatus,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: book.rentalExpired ? Colors.red : Colors.black,
//                                 ),
//                               ),
//
//                               // Re-rent Button (if rentalExpired is true)
//                               if (book.rentalExpired)
//                                 Padding(
//                                   padding: EdgeInsets.only(left: 8.0),
//                                   child: SizedBox(
//                                     width: 75,
//                                     height: 30,
//                                     child: ElevatedButton(
//                                       onPressed: (){},
//                                       style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.pink,
//                                           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(5.0),
//                                           )
//                                       ),
//                                       child: Text(
//                                         'Re-rent',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//     ),
//     );
//   }
// }
