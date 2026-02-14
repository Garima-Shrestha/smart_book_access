import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/features/category/presentation/page/category_page.dart';
import 'package:smart_book_access/features/category/presentation/view_model/category_view_model.dart';


// Lists of Categories
final List<String> categories = ['Fiction', 'Fantasy', 'Non Fiction', 'Children', 'History'];


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryViewModelProvider);

    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Search Bar
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 20.0, left: 30.0, right: 30.0),
              child: SizedBox(
                height: 40,
                // width: 380,
                width: double.infinity,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage()),
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/banner.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),


            // Category
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0, bottom: 17.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Categories", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CategoryPage()),
                      );
                    },
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
                    itemCount: categoryState.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryState.categories[index];
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryPage(scrollToIndex: index),
                              ),
                            );
                          },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue.shade100,
                        ),
                        alignment: Alignment.center,     // keeping text in center for each box
                        child: Text(
                          category.categoryName,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      ),
                      );
                    },
                  )
              ),
            ),

            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}