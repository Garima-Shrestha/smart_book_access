import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_book_access/core/api/api_client.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/utils/snackbar_utils.dart';
import 'package:smart_book_access/core/services/storage/token_service.dart';

import 'package:smart_book_access/features/bookAccess/presentation/page/pdf_reader_page.dart';

class MyQuotesPage extends ConsumerStatefulWidget {
  const MyQuotesPage({super.key});

  @override
  ConsumerState<MyQuotesPage> createState() => _MyQuotesPageState();
}

class _TextSelection {
  final int start;
  final int end;

  const _TextSelection({required this.start, required this.end});

  factory _TextSelection.fromJson(Map<String, dynamic> json) {
    return _TextSelection(
      start: (json['start'] as num?)?.toInt() ?? 0,
      end: (json['end'] as num?)?.toInt() ?? 0,
    );
  }
}

class _Quote {
  final int page;
  final String text;
  final _TextSelection? selection;

  const _Quote({
    required this.page,
    required this.text,
    this.selection,
  });

  factory _Quote.fromJson(Map<String, dynamic> json) {
    return _Quote(
      page: (json['page'] as num?)?.toInt() ?? 1,
      text: (json['text'] ?? '').toString(),
      selection: (json['selection'] is Map<String, dynamic>)
          ? _TextSelection.fromJson(json['selection'] as Map<String, dynamic>)
          : null,
    );
  }
}

class _BookMini {
  final String id;
  final String title;
  final String? author;
  final String? coverImageUrl;

  const _BookMini({
    required this.id,
    required this.title,
    this.author,
    this.coverImageUrl,
  });

  factory _BookMini.fromDynamic(dynamic v) {
    if (v is String) {
      return _BookMini(id: v, title: 'Untitled book');
    }
    if (v is Map<String, dynamic>) {
      final id = (v['_id'] ?? v['id'] ?? '').toString();
      return _BookMini(
        id: id,
        title: (v['title'] ?? 'Untitled book').toString(),
        author: (v['author'] as String?)?.toString(),
        coverImageUrl: (v['coverImageUrl'] as String?)?.toString(),
      );
    }
    return const _BookMini(id: '', title: 'Untitled book');
  }
}

class _BookAccessRow {
  final String id;
  final _BookMini book;
  final bool? isActive;
  final DateTime? expiresAt;
  final List<_Quote> quotes;

  const _BookAccessRow({
    required this.id,
    required this.book,
    required this.quotes,
    this.isActive,
    this.expiresAt,
  });

  factory _BookAccessRow.fromJson(Map<String, dynamic> json) {
    final book = _BookMini.fromDynamic(json['book']);

    DateTime? expires;
    final expiresRaw = json['expiresAt'];
    if (expiresRaw != null) {
      expires = DateTime.tryParse(expiresRaw.toString());
    }

    final quotesRaw = (json['quotes'] as List?) ?? const [];
    final quotes = quotesRaw
        .whereType<Map<String, dynamic>>()
        .map((e) => _Quote.fromJson(e))
        .toList();

    return _BookAccessRow(
      id: (json['_id'] ?? '').toString(),
      book: book,
      isActive: json['isActive'] is bool ? (json['isActive'] as bool) : null,
      expiresAt: expires,
      quotes: quotes,
    );
  }
}

class _FlattenedQuote {
  final String bookId;
  final String accessId;

  final String bookTitle;
  final String? bookAuthor;
  final String? coverImageUrl;

  final int quoteIndex;
  final _Quote quote;

  final bool isExpired;

  const _FlattenedQuote({
    required this.bookId,
    required this.accessId,
    required this.bookTitle,
    required this.quoteIndex,
    required this.quote,
    required this.isExpired,
    this.bookAuthor,
    this.coverImageUrl,
  });
}

class _MyQuotesPageState extends ConsumerState<MyQuotesPage> {
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;

  int _page = 1;
  final int _pageSize = 20;

  final ScrollController _scrollController = ScrollController();

  List<_BookAccessRow> _rows = [];
  _FlattenedQuote? _removing;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (!_hasMore) return;
      if (_loading || _loadingMore) return;

      final pos = _scrollController.position;
      if (pos.pixels >= pos.maxScrollExtent - 250) {
        _fetchAccesses(_page + 1, append: true);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAccesses(1, append: false);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String? _buildFullMediaUrl(String? pathOrUrl) {
    if (pathOrUrl == null || pathOrUrl.trim().isEmpty) return null;
    final v = pathOrUrl.trim();
    if (v.startsWith("http://") || v.startsWith("https://")) return v;
    return "${ApiEndpoints.serverUrl}$v";
  }

  bool _isExpiredRow(_BookAccessRow access) {
    if (access.isActive == false) return true;
    if (access.expiresAt == null) return false;
    return !access.expiresAt!.isAfter(DateTime.now());
  }

  Future<void> _fetchAccesses(int page, {required bool append}) async {
    if (!append) {
      setState(() {
        _loading = true;
        _loadingMore = false;
        _hasMore = true;
        _page = 1;
      });
    } else {
      setState(() {
        _loadingMore = true;
      });
    }

    try {
      final apiClient = ref.read(apiClientProvider);
      final tokenService = ref.read(tokenServiceProvider);
      final token = tokenService.getToken();

      if (token == null || token.isEmpty) {
        if (!mounted) return;
        SnackbarUtils.showError(context, "Please login again");
        setState(() {
          _rows = [];
          _loading = false;
          _loadingMore = false;
          _hasMore = false;
        });
        return;
      }

      final res = await apiClient.get(
        ApiEndpoints.getUserRentedBooks,
        queryParameters: {"page": page, "size": _pageSize},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (res.data?["success"] == true) {
        final list = (res.data?["data"] as List?) ?? const [];
        final parsed = <_BookAccessRow>[];

        for (final item in list) {
          if (item is Map<String, dynamic>) {
            parsed.add(_BookAccessRow.fromJson(item));
          }
        }

        final gotCount = parsed.length;
        final noMore = gotCount < _pageSize;

        if (!mounted) return;
        setState(() {
          if (append) {
            _rows.addAll(parsed);
            _page = page;
          } else {
            _rows = parsed;
            _page = 1;
          }

          _hasMore = !noMore;
          _loading = false;
          _loadingMore = false;
        });
        return;
      }

      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadingMore = false;
        if (!append) _rows = [];
      });
      SnackbarUtils.showError(
        context,
        res.data?["message"]?.toString() ?? "Failed to load quotes",
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadingMore = false;
        if (!append) _rows = [];
      });
      SnackbarUtils.showError(context, "Failed to load quotes");
    }
  }

  List<MapEntry<String, List<_FlattenedQuote>>> _groupedQuotes() {
    final flat = <_FlattenedQuote>[];

    for (final access in _rows) {
      if (access.book.id.isEmpty) continue;
      if (access.quotes.isEmpty) continue;

      final expired = _isExpiredRow(access);

      for (int i = 0; i < access.quotes.length; i++) {
        final q = access.quotes[i];
        if (q.text.trim().isEmpty) continue;

        flat.add(
          _FlattenedQuote(
            bookId: access.book.id,
            accessId: access.id,
            bookTitle: access.book.title,
            bookAuthor: access.book.author,
            coverImageUrl: access.book.coverImageUrl,
            quoteIndex: i,
            quote: q,
            isExpired: expired,
          ),
        );
      }
    }

    final map = <String, List<_FlattenedQuote>>{};
    for (final item in flat) {
      map.putIfAbsent(item.bookId, () => []);
      map[item.bookId]!.add(item);
    }

    return map.entries.toList();
  }

  Future<void> _removeQuote(_FlattenedQuote item) async {
    setState(() {
      _removing = item;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final tokenService = ref.read(tokenServiceProvider);
      final token = tokenService.getToken();

      if (token == null || token.isEmpty) {
        if (!mounted) return;
        SnackbarUtils.showError(context, "Please login again");
        setState(() => _removing = null);
        return;
      }

      final res = await apiClient.delete(
        ApiEndpoints.removeQuote(item.bookId),
        data: {"index": item.quoteIndex},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (!mounted) return;

      if (res.data?["success"] == true) {
        SnackbarUtils.showSuccess(context, "Quote removed");
        setState(() => _removing = null);
        await _fetchAccesses(1, append: false);
        return;
      }

      SnackbarUtils.showError(
        context,
        res.data?["message"]?.toString() ?? "Failed to remove quote",
      );
      setState(() => _removing = null);
    } catch (_) {
      if (!mounted) return;
      SnackbarUtils.showError(context, "Failed to remove quote");
      setState(() => _removing = null);
    }
  }

  Future<void> _copyQuote(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    SnackbarUtils.showSuccess(context, "Copied");
  }

  void _openBookIfAllowed({
    required String bookId,
    required String title,
    required bool expired,
  }) {
    if (expired) {
      SnackbarUtils.showError(context, "Rent expired. You can still view quotes here.");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfReaderPage(
          bookId: bookId,
          title: title,
        ),
      ),
    );
  }

  Widget _statusChip(bool expired) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: expired ? const Color(0xFFFFE5E5) : const Color(0xFFE6F6EA),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        expired ? "expired" : "active",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: expired ? const Color(0xFFB00020) : const Color(0xFF1B5E20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedQuotes();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "My Quotes",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () => _fetchAccesses(1, append: false),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchAccesses(1, append: false),
        child: _loading
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(
              child: Text(
                "Loading your quotes…",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
          ],
        )
            : grouped.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Icon(Icons.format_quote_outlined, size: 52, color: Colors.black26),
            SizedBox(height: 14),
            Center(
              child: Text(
                "No quotes yet",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  "Select text in a PDF and save it as a quote.\nYour quotes remain visible here even if the rent expires.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ),
            ),
          ],
        )
            : ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: grouped.length + 1,
          itemBuilder: (_, idx) {
            if (idx == grouped.length) {
              if (_loadingMore) {
                return const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 18),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (!_hasMore) {
                return const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 18),
                  child: Center(
                    child: Text(
                      "That's all",
                      style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox(height: 18);
            }

            final entry = grouped[idx];
            final items = entry.value;
            final first = items.first;

            final hasActiveNow = items.any((x) => !x.isExpired);
            final expired = !hasActiveNow;
            final coverUrl = _buildFullMediaUrl(first.coverImageUrl);

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE6E6E6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header (white)
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          height: 58,
                          width: 44,
                          decoration: BoxDecoration(
                            color: Colors.white, // ✅ removed grey cover bg
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE6E6E6)),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: coverUrl == null
                              ? const Icon(Icons.menu_book_outlined, color: Colors.black26, size: 26)
                              : Image.network(
                            coverUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.menu_book_outlined,
                              color: Colors.black26,
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                first.bookTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                first.bookAuthor != null && first.bookAuthor!.trim().isNotEmpty
                                    ? "by ${first.bookAuthor}"
                                    : "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.black54, fontSize: 14),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  _statusChip(expired),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${items.length} quotes",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!expired)
                          TextButton(
                            onPressed: () => _openBookIfAllowed(
                              bookId: first.bookId,
                              title: first.bookTitle,
                              expired: expired,
                            ),
                            child: const Text(
                              "Open book",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),
                  const Divider(
                    height: 18,       // gives breathing space
                    thickness: 0.8,   // softer than 1
                    indent: 14,       // inset from left
                    endIndent: 14,    // inset from right
                    color: Color(0xFFE6E6E6),
                  ),

                  // Quotes list (white cards)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(14),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final item = items[i];
                      final isRemoving = _removing != null &&
                          _removing!.bookId == item.bookId &&
                          _removing!.quoteIndex == item.quoteIndex;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white, // ✅ removed grey background here too
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE6E6E6)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _copyQuote(item.quote.text),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Page ${item.quote.page}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        _statusChip(expired),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      item.quote.text,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        height: 1.35,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Tap to copy",
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: isRemoving ? null : () => _removeQuote(item),
                              icon: isRemoving
                                  ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                                  : const Icon(Icons.delete, color: Colors.redAccent),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}