import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:smart_book_access/core/api/api_client.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/services/storage/token_service.dart';
import 'package:smart_book_access/features/book/presentation/page/book_detail_page.dart';
import 'package:smart_book_access/features/book/presentation/view_model/book_view_model.dart';
import 'package:smart_book_access/features/bookAccess/presentation/page/pdf_reader_page.dart';
import 'package:smart_book_access/features/library/presentation/view_model/my_library_view_model.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String? _navigatingBookId;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String _resolveCoverUrl(String? raw) {
    if (raw == null) return '';
    final v = raw.trim();
    if (v.isEmpty) return '';
    if (v.startsWith('http://') || v.startsWith('https://')) return v;
    if (v.startsWith('/')) return '${ApiEndpoints.serverUrl}$v';
    return '${ApiEndpoints.serverUrl}/$v';
  }

  Future<void> _handleBookTap(book) async {
    if (_navigatingBookId != null) return;
    setState(() => _navigatingBookId = book.bookId);
    try {
      final apiClient = ref.read(apiClientProvider);
      final tokenService = ref.read(tokenServiceProvider);
      final token = await tokenService.getToken();
      bool isRented = false;
      try {
        final res = await apiClient.get(
          ApiEndpoints.getBookAccess(book.bookId!),
          options: Options(headers: {"Authorization": "Bearer $token"}),
        );
        isRented = res.data?['success'] == true;
      } catch (_) {
        isRented = false;
      }
      if (!mounted) return;
      if (isRented) {
        await Navigator.push(context, MaterialPageRoute(
          builder: (_) => PdfReaderPage(bookId: book.bookId!, title: book.title),
        ));
      } else {
        await Navigator.push(context, MaterialPageRoute(
          builder: (_) => BookDetailsPage(book: book),
        ));
      }
    } finally {
      if (mounted) setState(() => _navigatingBookId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryViewModelProvider);
    final bookState = ref.watch(bookViewModelProvider);
    final libState = ref.watch(myLibraryViewModelProvider);

    final _filteredBooks = _searchQuery.trim().isEmpty
        ? []
        : bookState.books
        .where((b) => b.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    final _newArrivals = bookState.books.reversed.take(6).toList();

    final _readingNow = libState.books
        .where((b) => !b.isExpired && !b.isInactive)
        .take(4)
        .toList();

    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 0.0, left: 30.0, right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                              onPressed: () => setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              }),
                            )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (_searchQuery.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 52),
                          child: Container(
                            constraints: const BoxConstraints(maxHeight: 260),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFEEEEEE)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _filteredBooks.isEmpty
                                ? Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'No books found for "$_searchQuery"',
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            )
                                : ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: _filteredBooks.length,
                              separatorBuilder: (_, __) =>
                              const Divider(height: 1, color: Color(0xFFF0F0F0)),
                              itemBuilder: (context, index) {
                                final book = _filteredBooks[index];
                                final cover = _resolveCoverUrl(book.coverImageUrl);
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: cover.isNotEmpty
                                        ? CachedNetworkImage(
                                      imageUrl: cover,
                                      width: 36,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) =>
                                      const Icon(Icons.menu_book, size: 36),
                                    )
                                        : const Icon(Icons.menu_book, size: 36),
                                  ),
                                  title: Text(
                                    book.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: Text(
                                    book.author,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey),
                                  ),
                                  trailing: _navigatingBookId == book.bookId
                                      ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                      : null,
                                  onTap: () {
                                    _searchFocusNode.unfocus();
                                    setState(() {
                                      _searchQuery = '';
                                      _searchController.clear();
                                    });
                                    _handleBookTap(book);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Promotion Banner
            SizedBox(height: 12),
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

            SizedBox(height: 30),
            // Reading Now
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Reading Now", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: _readingNow.isEmpty
                  ? Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFD8E2FF), width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD8E2FF), width: 1),
                        ),
                        child: const Icon(Icons.menu_book_rounded,
                            color: Color(0xFF3B5BDB), size: 22),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your shelf is waiting',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Ready for your next read?',
                              style: TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => CategoryPage())),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B5BDB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Find a Book',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : SizedBox(
                height: 260,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _readingNow.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = _readingNow[index];
                    final cover = _resolveCoverUrl(item.coverImageUrl);
                    final progress = (item.progressPercent.clamp(0, 100)) / 100.0;
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PdfReaderPage(
                                bookId: item.bookId, title: item.title),
                          ),
                        );
                        await ref
                            .read(myLibraryViewModelProvider.notifier)
                            .fetchMyLibrary();
                      },
                      child: SizedBox(
                        width: 130,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 130,
                              height: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFFF0F0F0),
                                image: cover.isNotEmpty
                                    ? DecorationImage(
                                  image: CachedNetworkImageProvider(cover),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: cover.isEmpty
                                  ? const Icon(Icons.menu_book, color: Colors.grey, size: 36)
                                  : null,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: progress,
                              minHeight: 4,
                              backgroundColor: Colors.black12,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF1E3A8A)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${item.progressPercent}%',
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E3A8A)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // New Arrivals
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 24.0, bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("New Arrivals", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => CategoryPage())),
                    child: Text("See all",
                        style: TextStyle(fontSize: 16, color: Color(0xFF1A68EE))),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _newArrivals.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final book = _newArrivals[index];
                    final cover = _resolveCoverUrl(book.coverImageUrl);
                    return GestureDetector(
                      onTap: () => _handleBookTap(book),
                      child: SizedBox(
                        width: 130,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 130,
                              height: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFFF0F0F0),
                                image: cover.isNotEmpty
                                    ? DecorationImage(
                                  image: CachedNetworkImageProvider(cover),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: cover.isEmpty
                                  ? const Icon(Icons.menu_book, color: Colors.grey, size: 36)
                                  : null,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              book.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              book.author,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}