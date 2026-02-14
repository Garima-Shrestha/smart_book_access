import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/widgets/my_button.dart';
import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';
import 'package:smart_book_access/features/category/presentation/view_model/category_view_model.dart';

class BookDetailsPage extends ConsumerWidget {
  final BookEntity book;

  const BookDetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(categoryViewModelProvider);
    final categoryName = categoryState.categories.isEmpty
        ? "Loading..."
        : categoryState.categories
        .firstWhere((cat) => cat.categoryId == book.genre,
        orElse: () => categoryState.categories.first)
        .categoryName;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD6E4FF),
        elevation: 0,
        toolbarHeight: 56.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Image Section
            Container(
              color: const Color(0xFFD6E4FF),
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              child: Center(
                child: Container(
                  height: 280,
                  width: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],
                    image: DecorationImage(
                      image: NetworkImage('${ApiEndpoints.serverUrl}${book.coverImageUrl}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          book.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Rs.${book.price.toInt()}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  // Author
                  Text(
                    "by ${book.author}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF888888),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // About section
                  const Text(
                    "About the book",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    book.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF444444),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Metadata List
                  _infoRow("Genre", categoryName),
                  _infoRow("Publication Date", book.publishedDate),
                  _infoRow("Pages", book.pages.toString()),

                  const SizedBox(height: 50),

                  // Rent Button (Using your MyButton widget)
                  Center(
                    child: SizedBox(
                      width: 220,
                      height: 51,
                      child: MyButton(
                        text: "Rent Now",
                        color: const Color(0xFF9F0000),
                        onPressed: () {
                          // Logic for renting using ref.read() goes here
                        },
                        // isLoading can be passed here from a RentViewModel state later
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF444444),
            ),
          ),
        ],
      ),
    );
  }
}