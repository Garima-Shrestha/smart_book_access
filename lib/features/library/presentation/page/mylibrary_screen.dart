import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_book_access/core/api/api_client.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/services/storage/token_service.dart';
import 'package:smart_book_access/core/utils/snackbar_utils.dart';

import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';
import 'package:smart_book_access/features/book/presentation/page/book_detail_page.dart';
import 'package:smart_book_access/features/bookAccess/presentation/page/pdf_reader_page.dart';

import 'package:smart_book_access/features/library/domain/entities/my_library_entity.dart';
import 'package:smart_book_access/features/library/presentation/state/my_library_state.dart';
import 'package:smart_book_access/features/library/presentation/view_model/my_library_view_model.dart';

class MylibraryScreen extends ConsumerStatefulWidget {
  const MylibraryScreen({super.key});

  @override
  ConsumerState<MylibraryScreen> createState() => _MylibraryScreenState();
}

class _MylibraryScreenState extends ConsumerState<MylibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final libState = ref.watch(myLibraryViewModelProvider);

    ref.listen<MyLibraryState>(myLibraryViewModelProvider, (prev, next) {
      if (next.status == MyLibraryStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
        ref.read(myLibraryViewModelProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Library",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 22),
            if (libState.status == MyLibraryStatus.loading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 10),
                  itemCount: libState.books.length,
                  itemBuilder: (context, index) {
                    final item = libState.books[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _MyLibraryCard(
                        item: item,
                        onTap: () async {
                          if (item.isExpired) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookDetailsLoaderPage(
                                  bookId: item.bookId,
                                ),
                              ),
                            );
                          } else {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PdfReaderPage(
                                  bookId: item.bookId,
                                  title: item.title,
                                ),
                              ),
                            );
                          }

                          await ref
                              .read(myLibraryViewModelProvider.notifier)
                              .fetchMyLibrary();
                        },
                        onReRent: item.isExpired
                            ? () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookDetailsLoaderPage(
                                bookId: item.bookId,
                              ),
                            ),
                          );

                          await ref
                              .read(myLibraryViewModelProvider.notifier)
                              .fetchMyLibrary();
                        }
                            : null,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MyLibraryCard extends StatelessWidget {
  final MyLibraryEntity item;
  final Future<void> Function() onTap;
  final Future<void> Function()? onReRent;

  const _MyLibraryCard({
    required this.item,
    required this.onTap,
    required this.onReRent,
  });

  String? _resolveCoverUrl(String? raw) {
    if (raw == null) return null;
    final v = raw.trim();
    if (v.isEmpty) return null;

    if (v.startsWith('http://') || v.startsWith('https://')) return v;

    if (v.startsWith('/')) return '${ApiEndpoints.serverUrl}$v';
    return '${ApiEndpoints.serverUrl}/$v';
  }

  @override
  Widget build(BuildContext context) {
    final coverUrl = _resolveCoverUrl(item.coverImageUrl);
    final progressValue = (item.progressPercent.clamp(0, 100)) / 100.0;

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFD7E2F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: 103,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              clipBehavior: Clip.antiAlias,
              child: coverUrl == null
                  ? const Center(child: Icon(Icons.menu_book, size: 44))
                  : Image.network(
                coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image, size: 44),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${item.pages} Pages",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Progress: ${item.progressPercent}%",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      minHeight: 5,
                      backgroundColor: Colors.black12,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF64B5F6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.isExpired
                              ? "Rental Expired"
                              : "Time left: ${item.timeLeftLabel.replaceAll('Time left ', '')}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (item.isExpired && onReRent != null) ...[
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              onReRent!();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B0000),
                              shape: const StadiumBorder(),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                            ),
                            child: const Text(
                              "Re-rent",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookDetailsLoaderPage extends ConsumerStatefulWidget {
  final String bookId;

  const BookDetailsLoaderPage({super.key, required this.bookId});

  @override
  ConsumerState<BookDetailsLoaderPage> createState() =>
      _BookDetailsLoaderPageState();
}

class _BookDetailsLoaderPageState extends ConsumerState<BookDetailsLoaderPage> {
  bool _loading = true;
  String? _error;
  BookEntity? _book;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadBook);
  }

  Future<void> _loadBook() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final token = ref.read(tokenServiceProvider).getToken();

      final res = await apiClient.get(
        ApiEndpoints.getBookById(widget.bookId),
        options: Options(
          headers: token == null ? {} : {"Authorization": "Bearer $token"},
        ),
      );

      if (res.data == null || res.data['success'] != true) {
        setState(() {
          _loading = false;
          _error = "Failed to load book";
        });
        return;
      }

      final data = res.data['data'] as Map<String, dynamic>;

      final book = BookEntity(
        bookId: (data['_id'] ?? data['id']).toString(),
        title: (data['title'] ?? '').toString(),
        author: (data['author'] ?? '').toString(),
        description: (data['description'] ?? '').toString(),
        genre: (data['genre'] ?? '').toString(),
        publishedDate: (data['publishedDate'] ?? '').toString(),
        pages: (data['pages'] is int)
            ? data['pages'] as int
            : int.tryParse(data['pages'].toString()) ?? 0,
        price: (data['price'] is num)
            ? (data['price'] as num).toDouble()
            : double.tryParse(data['price'].toString()) ?? 0,
        coverImageUrl: (data['coverImageUrl'] ?? '').toString(),
      );

      setState(() {
        _loading = false;
        _book = book;
      });
    } on DioException catch (e) {
      setState(() {
        _loading = false;
        _error = e.response?.data?['message']?.toString() ??
            e.message ??
            "Request failed";
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(toolbarHeight: 0.0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(toolbarHeight: 0.0),
        body: Center(child: Text(_error!)),
      );
    }

    return BookDetailsPage(book: _book!);
  }
}