import 'package:flutter/material.dart';
import 'package:smart_book_access/model/book.dart';
import 'package:smart_book_access/screens/category_screen.dart';

// BestSeller Book List
final List<Book> bestSellers = [
  Book(
      bookName: "The Design of Books",
      authName: 'Debbie Barne',
      image: 'assets/images/designBook.png',
  ),
  Book(
    bookName: "Charlotte's Web",
    authName: 'E.B. White',
    image: 'assets/images/charlotteBook.png',
  ),
  Book(
    bookName: "Atomic Habits",
    authName: 'James Clear',
    image: 'assets/images/atomicBook.png',
  ),
  Book(
    bookName: "The Alchemist",
    authName: 'Paulo Coelho',
    image: 'assets/images/alchemistBook.png',
  ),
  Book(
    bookName: "Harry Potter",
    authName: 'J. K. Rowling',
    image: 'assets/images/potterBook.png',
  ),
];


// Reading Now Book list
final List<Book> readingNow = [
  Book(
    bookName: "The Names",
    authName: 'Florence Knapp',
    image: 'assets/images/namesBook.png',
  ),
  Book(
    bookName: "Never Ending Sky",
    authName: 'Joseph Kirkland',
    image: 'assets/images/skyBook.png',
  ),
  Book(
    bookName: "The Psychology of Money",
    authName: 'Morgan Housel',
    image: 'assets/images/psychologyBook.png',
  ),
];

// Lists of Categories
final List<String> categories = ['Fiction', 'Fantasy', 'Non Fiction', 'Children', 'History'];

class HomepageScreen extends StatelessWidget {
  const HomepageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Search Bar
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 20.0, left: 30.0, right: 30.0),
              child: SizedBox(
                height: 40,
                width: 380,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.zero,  // All internal padding is removed
                  ),
                ),
              ),
            ),


            // Promotion Banner
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => CategoryScreen()),
                );
              },
                child: Image.asset("assets/images/banner.png")
            ),


            // Category
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0, bottom: 17.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Categories", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: Text("See all", style: TextStyle(fontSize: 16, color: Color(0xFF1A68EE))),
                  ),
                ],
              ),
            ),

            // Category Scrollable Horizontal
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue.shade100,
                          ),
                          alignment: Alignment.center,    // keeping text in center for each box
                          child: Text(
                            category,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                        );
                      },
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
