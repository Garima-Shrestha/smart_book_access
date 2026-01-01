// import 'package:flutter/material.dart';
// import 'package:smart_book_access/model/book.dart';
// import 'package:smart_book_access/screens/category_screen.dart';
// import 'package:smart_book_access/widgets/book_section.dart';
//
// // BestSeller Book List
// final List<Book> bestSellers = [
//   Book(
//     bookName: "The Design of Books",
//     authName: 'Debbie Barne',
//     image: 'assets/images/designBook.jpg',
//   ),
//   Book(
//     bookName: "Charlotte's Web",
//     authName: 'E.B. White',
//     image: 'assets/images/charlotteBook.jpg',
//   ),
//   Book(
//     bookName: "Atomic Habits",
//     authName: 'James Clear',
//     image: 'assets/images/atomicBook.jpg',
//   ),
//   Book(
//     bookName: "The Alchemist",
//     authName: 'Paulo Coelho',
//     image: 'assets/images/alchemistBook.jpg',
//   ),
//   Book(
//     bookName: "Harry Potter",
//     authName: 'J. K. Rowling',
//     image: 'assets/images/potterBook.jpg',
//   ),
// ];
//
//
// // Reading Now Book list
// final List<Book> readingNow = [
//   Book(
//     bookName: "The Names",
//     authName: 'Florence Knapp',
//     image: 'assets/images/namesBook.jpg',
//   ),
//   Book(
//     bookName: "Never Ending Sky",
//     authName: 'Joseph Kirkland',
//     image: 'assets/images/skyBook.jpg',
//   ),
//   Book(
//     bookName: "The Psychology of Money",
//     authName: 'Morgan Housel',
//     image: 'assets/images/psychologyBook.jpg',
//   ),
// ];
//
// // Lists of Categories
// final List<String> categories = ['Fiction', 'Fantasy', 'Non Fiction', 'Children', 'History'];
//
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             //Search Bar
//             SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.only(top: 30.0, bottom: 20.0, left: 30.0, right: 30.0),
//               child: SizedBox(
//                 height: 40,
//                 // width: 380,
//                 width: double.infinity,
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Search',
//                     prefixIcon: Icon(Icons.search, color: Colors.grey),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     contentPadding: EdgeInsets.zero,  // All internal padding is removed
//                   ),
//                 ),
//               ),
//             ),
//
//
//             // Promotion Banner
//             SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30.0),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => CategoryScreen()),
//                   );
//                 },
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: Image.asset(
//                     "assets/images/banner.png",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//
//
//             // Category
//             Padding(
//               padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0, bottom: 17.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Categories", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
//                   TextButton(
//                     onPressed: () {},
//                     child: Text("See all", style: TextStyle(fontSize: 16, color: Color(0xFF1A68EE))),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Category Scrollable Horizontal
//             Padding(
//               padding: const EdgeInsets.only(left: 25.0),
//               child: SizedBox(
//                   height: 40,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: categories.length,
//                     itemBuilder: (context, index) {
//                       final category = categories[index];
//                       return Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         margin: const EdgeInsets.only(left: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.blue.shade100,
//                         ),
//                         alignment: Alignment.center,     // keeping text in center for each box
//                         child: Text(
//                           category,
//                           style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
//                         ),
//                       );
//                     },
//                   )
//               ),
//             ),
//
//             BookSection(title: 'Best Sellers', books: bestSellers),
//
//             BookSection(title: "Reading Now", books: readingNow),
//
//             SizedBox(height: 50),
//           ],
//         ),
//       ),
//     );
//   }
// }
