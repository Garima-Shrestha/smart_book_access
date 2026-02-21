import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/utils/snackbar_utils.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
import 'package:smart_book_access/features/bookAccess/presentation/view_model/book_access_view_model.dart';

class BookmarkQuotePage extends ConsumerStatefulWidget {
  final String bookId;
  final String title;

  const BookmarkQuotePage({
    super.key,
    required this.bookId,
    required this.title,
  });

  @override
  ConsumerState<BookmarkQuotePage> createState() =>
      _BookmarkQuotePageState();
}

class _BookmarkQuotePageState
    extends ConsumerState<BookmarkQuotePage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookAccessViewModelProvider);
    final access = state.bookAccess;

    final bookmarks = access?.bookmarks ?? [];
    final quotes = access?.quotes ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tab,
          labelColor: Colors.black,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: "BOOKMARKS"),
            Tab(text: "QUOTES"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildList(bookmarks, true),
          _buildList(quotes, false),
        ],
      ),
    );
  }

  Widget _buildList(List<dynamic> list, bool isBookmark) {
    if (list.isEmpty) {
      return const Center(
        child: Text("No data yet",
            style: TextStyle(color: Colors.black54)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFDDE8FF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, {
                      "type": isBookmark ? "bookmark" : "quote",
                      "page": list[i].page,
                      "text": list[i].text,
                    });
                  },
                  child: Text(
                    list[i].text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == "copy") {
                    await Clipboard.setData(
                        ClipboardData(text: list[i].text));
                    SnackbarUtils.showSuccess(context, "Copied");
                  } else if (value == "delete") {
                    if (isBookmark) {
                      await ref
                          .read(bookAccessViewModelProvider.notifier)
                          .removeBookmark(widget.bookId, i);
                    } else {
                      await ref
                          .read(bookAccessViewModelProvider.notifier)
                          .removeQuote(widget.bookId, i);
                    }
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                      value: "copy", child: Text("Copy")),
                  PopupMenuItem(
                      value: "delete", child: Text("Delete")),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}