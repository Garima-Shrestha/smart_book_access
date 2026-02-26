import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/utils/snackbar_utils.dart';
import 'package:smart_book_access/features/book/presentation/page/book_detail_page.dart';
import 'package:smart_book_access/features/book/presentation/state/book_state.dart';
import 'package:smart_book_access/features/book/presentation/view_model/book_view_model.dart';
import 'package:smart_book_access/features/bookAccess/presentation/page/pdf_reader_page.dart';
import 'package:smart_book_access/features/category/presentation/view_model/category_view_model.dart';
import 'package:smart_book_access/features/history/presentation/state/history_state.dart';
import 'package:smart_book_access/features/history/presentation/view_model/history_view_model.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String? _pendingBookId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(historyViewModelProvider.notifier).getMyHistory(page: 1, size: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(historyViewModelProvider);
    final categoryState = ref.watch(categoryViewModelProvider);

    ref.listen<HistoryState>(historyViewModelProvider, (prev, next) {
      if (next.status == HistoryStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
        ref.read(historyViewModelProvider.notifier).clearError();
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
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              "History",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            if (historyState.status == HistoryStatus.loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (historyState.historyList.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "No history found",
                    style: TextStyle(color: Color(0xFF888888), fontSize: 16),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: historyState.historyList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = historyState.historyList[index];
                    final activeBookIds = historyState.historyList
                        .where((x) => !(x.isExpired || x.isInactive))
                        .map((x) => x.bookId)
                        .toSet();

                    final bool hasActiveNow = activeBookIds.contains(item.bookId);
                    final bool blocked = item.isExpired || item.isInactive;

                    final genreName = (categoryState.categories.isEmpty)
                        ? (item.genre ?? "")
                        : categoryState.categories
                        .firstWhere(
                          (cat) => cat.categoryId == item.genre,
                      orElse: () => categoryState.categories.first,
                    )
                        .categoryName;

                    Future<void> openCorrectPage() async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PdfReaderPage(
                            bookId: item.bookId,
                            title: item.title ?? "",
                          ),
                        ),
                      );
                    }

                    final coverUrl = (item.coverImageUrl == null || item.coverImageUrl!.isEmpty)
                        ? null
                        : "${ApiEndpoints.serverUrl}${item.coverImageUrl}";

                    return GestureDetector(
                      onTap: openCorrectPage,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6E4FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 112,
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                image: coverUrl == null
                                    ? null
                                    : DecorationImage(
                                  image: NetworkImage(coverUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: coverUrl == null
                                  ? const Center(child: Icon(Icons.menu_book, size: 42))
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.author ?? "",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4B4B4B),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${item.pages} Pages  •  $genreName",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Rented: ${_formatDate(item.rentedAt)}",
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Expiry: ${_formatDate(item.expiresAt)}",
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                  if ((item.isExpired || item.isInactive) && hasActiveNow) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      "Already re-rented — open the book.",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2563EB),
                                      ),
                                    ),
                                  ],
                                  if ((item.isExpired || item.isInactive) && !hasActiveNow) ...[
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: 140,
                                        height: 38,
                                        child: ElevatedButton(
                                          onPressed: openCorrectPage,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF9F0000),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(22),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: const Text(
                                            "Re-rent",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
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

  static String _formatDate(DateTime? date) {
    if (date == null) return "-";
    const months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}