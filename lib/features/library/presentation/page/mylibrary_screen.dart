import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/utils/snackbar_utils.dart';
import 'package:smart_book_access/features/book/presentation/page/book_detail_page.dart';
import 'package:smart_book_access/features/book/presentation/state/book_state.dart';
import 'package:smart_book_access/features/book/presentation/view_model/book_view_model.dart';
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
  String? _pendingBookId;

  @override
  Widget build(BuildContext context) {
    final libState = ref.watch(myLibraryViewModelProvider);

    ref.listen<MyLibraryState>(myLibraryViewModelProvider, (prev, next) {
      if (next.status == MyLibraryStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
        ref.read(myLibraryViewModelProvider.notifier).clearError();
      }
    });

    ref.listen<BookState>(bookViewModelProvider, (prev, next) async {
      if (_pendingBookId == null) return;

      if (next.status == BookStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
        ref.read(bookViewModelProvider.notifier).clearError();
        setState(() {
          _pendingBookId = null;
        });
        return;
      }

      if (next.status == BookStatus.success &&
          next.selectedBook != null &&
          next.selectedBook!.bookId == _pendingBookId) {
        final book = next.selectedBook!;
        setState(() {
          _pendingBookId = null;
        });

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailsPage(book: book),
          ),
        );

        await ref.read(myLibraryViewModelProvider.notifier).fetchMyLibrary();
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
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 40.0),
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

                    Future<void> openCorrectPage() async {
                      final blocked = item.isExpired || item.isInactive;

                      if (blocked) {
                        setState(() {
                          _pendingBookId = item.bookId;
                        });
                        await ref.read(bookViewModelProvider.notifier).getBookById(item.bookId);
                        return;
                      }

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PdfReaderPage(
                            bookId: item.bookId,
                            title: item.title,
                          ),
                        ),
                      );

                      await ref.read(myLibraryViewModelProvider.notifier).fetchMyLibrary();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _MyLibraryCard(
                        item: item,
                        onTap: openCorrectPage,
                        onReRent: item.canReRent
                            ? () async {
                          setState(() {
                            _pendingBookId = item.bookId;
                          });
                          await ref.read(bookViewModelProvider.notifier).getBookById(item.bookId);
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
                image: coverUrl == null
                    ? null
                    : DecorationImage(
                  image: NetworkImage(coverUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: coverUrl == null
                  ? const Center(child: Icon(Icons.menu_book, size: 44))
                  : null,
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
                  LinearProgressIndicator(
                    value: progressValue,
                    minHeight: 5,
                    backgroundColor: Colors.black12,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF64B5F6),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.isExpired
                              ? "Rental Expired"
                              : item.isInactive
                              ? "Inactive"
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
                      if (item.canReRent && onReRent != null) ...[
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