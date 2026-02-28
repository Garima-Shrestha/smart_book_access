import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/sensors/proximity_hold_service.dart';
import 'package:smart_book_access/core/sensors/shake_service.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:smart_book_access/core/api/api_client.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/services/hive/hive_service.dart';
import 'package:smart_book_access/core/services/storage/token_service.dart';
import 'package:smart_book_access/core/utils/snackbar_utils.dart';

import 'package:smart_book_access/features/book/data/models/book_hive_model.dart';
import 'package:smart_book_access/features/book/presentation/page/book_detail_page.dart';

import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
import 'package:smart_book_access/features/bookAccess/presentation/view_model/book_access_view_model.dart';

import 'bookmark_quote_page.dart';

class PdfReaderPage extends ConsumerStatefulWidget {
  final String bookId;
  final String title;

  const PdfReaderPage({
    super.key,
    required this.bookId,
    required this.title,
  });

  @override
  ConsumerState<PdfReaderPage> createState() => _PdfReaderPageState();
}

class _PdfReaderPageState extends ConsumerState<PdfReaderPage> {
  final PdfViewerController _controller = PdfViewerController();

  Timer? _debounce;
  PdfTextSearchResult? _searchResult;

  bool _checkingAccess = true;
  bool _accessAllowed = false;
  bool _restoredOnce = false;
  bool _sheetOpen = false;
  bool _savingEnabled = false;
  bool _docLoadedOnce = false;
  bool _restoringNow = false;
  bool _pdfLoadError = false;
  late ShakeService _shakeService;
  late ProximityHoldService _proximityService;

  late Future<File?> _cachedPdfFuture;

  @override
  void initState() {
    super.initState();

    _cachedPdfFuture = _getCachedPdfFileIfExists();

    _shakeService = ShakeService(
      onShake: () {
        if (!mounted) return;
        try {
          final nextPage = _controller.pageNumber + 1;
          _controller.jumpToPage(nextPage);
        } catch (_) {}
      },
    );
    _shakeService.start();

    _proximityService = ProximityHoldService(
      holdMs: 500,
      cooldownMs: 1500,
      onTriggered: () {
        if (!mounted) return;
        _openNotes();
      },
    );
    _proximityService.start();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ok = await _verifyAccess();
      if (!mounted) return;

      if (!ok) {
        _redirectToBookDetail();
        return;
      }

      await ref.read(bookAccessViewModelProvider.notifier).fetchBookAccess(widget.bookId);
      if (!mounted) return;

      final currentState = ref.read(bookAccessViewModelProvider);
      if (currentState.bookAccess == null) {
        await ref.read(bookAccessViewModelProvider.notifier).fetchBookAccessFromCache(widget.bookId);
        if (!mounted) return;
      }

      setState(() {
        _checkingAccess = false;
        _accessAllowed = true;
      });
    });
  }

  @override
  void dispose() {
    _shakeService.stop();
    _proximityService.stop();
    _debounce?.cancel();
    _searchResult?.clear();
    super.dispose();
  }

  Future<bool> _verifyAccess() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final tokenService = ref.read(tokenServiceProvider);
      final token = tokenService.getToken();

      if (token == null || token.isEmpty) {
        return await _verifyAccessFromCache();
      }

      final res = await apiClient.get(
        ApiEndpoints.getBookAccess(widget.bookId),
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (res.data?['success'] != true) return await _verifyAccessFromCache();

      final data = res.data['data'] as Map<String, dynamic>?;
      if (data == null) return await _verifyAccessFromCache();

      final isActive = data['isActive'];
      if (isActive is bool && isActive == false) return false;

      final expiresRaw = data['expiresAt'];
      if (expiresRaw != null) {
        final expiresAt = DateTime.tryParse(expiresRaw.toString());
        if (expiresAt != null && !expiresAt.isAfter(DateTime.now())) {
          return false;
        }
      }

      final pdfUrl = data['pdfUrl'];
      if (pdfUrl == null || pdfUrl.toString().trim().isEmpty) return false;

      return true;
    } catch (e, st) {
      return await _verifyAccessFromCache();
    }
  }

  Future<bool> _verifyAccessFromCache() async {
    try {
      final hive = ref.read(hiveServiceProvider);
      final cached = await hive.getBookAccess(widget.bookId);
      if (cached == null) return false;
      final pdfUrl = cached.pdfUrl;
      if (pdfUrl == null || pdfUrl.trim().isEmpty) return false;
      return true;
    } catch (_) {
      return false;
    }
  }

  void _redirectToBookDetail() {
    if (!mounted) return;

    final hive = ref.read(hiveServiceProvider);
    final BookHiveModel? cached = hive.getBookById(widget.bookId);

    if (cached != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookDetailsPage(book: cached.toEntity()),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _saveLastPosition(int page, double offset, double zoomLevel) {
    if (!_savingEnabled) return;
    if (!_docLoadedOnce && page == 1 && offset <= 2) return;
    final zoomPct = (zoomLevel * 100.0);

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      ref.read(bookAccessViewModelProvider.notifier).updatePosition(
        bookId: widget.bookId,
        position: LastPositionEntity(
          page: page,
          offsetY: offset,
          zoom: zoomPct,
        ),
      );
    });
  }

  void _restoreLastPositionOnce(BookAccessEntity access) {
    if (_restoredOnce) return;

    final pos = access.lastPosition;
    if (pos == null) {
      _restoredOnce = true;
      _savingEnabled = true;
      return;
    }

    _restoredOnce = true;
    _savingEnabled = false;
    _restoringNow = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        _docLoadedOnce = true;
        double zoomPct = (pos.zoom ?? 100.0);
        if (zoomPct > 0 && zoomPct <= 3.0) {
          zoomPct = zoomPct * 100.0;
        }
        final zoomLevel = (zoomPct / 100.0).clamp(0.7, 1.6);
        _controller.zoomLevel = zoomLevel;
        if (pos.page >= 1) {
          _controller.jumpToPage(pos.page);
        }

        await Future.delayed(const Duration(milliseconds: 250));
        if (pos.page >= 1) {
          _controller.jumpToPage(pos.page);
        }

        await Future.delayed(const Duration(milliseconds: 700));
      } catch (_) {
        // ignore
      } finally {
        if (!mounted) return;
        _restoringNow = false;
        _savingEnabled = true;
      }
    });
  }

  String _normalizeForSearch(String s) {
    var t = s;
    t = t.replaceAll(RegExp(r'-\s*\n\s*'), '');
    t = t.replaceAll(RegExp(r'\s+'), ' ').trim();

    return t;
  }

  Future<bool> _tryHighlightOnPage(String query, int targetPage) async {
    final q = query.trim();
    if (q.isEmpty) return false;

    _searchResult?.clear();
    _searchResult = await _controller.searchText(q);

    final total = _searchResult?.totalInstanceCount ?? 0;
    if (total <= 0) return false;

    for (int i = 0; i < total; i++) {
      _searchResult?.nextInstance();
      await Future.delayed(const Duration(milliseconds: 40));
      if (_controller.pageNumber == targetPage) {
        return true;
      }
    }

    return true;
  }

  Future<void> _highlightForFewSeconds({
    required String text,
    required int page,
    Duration duration = const Duration(seconds: 3),
  }) async {
    try {
      _controller.jumpToPage(page);
      await Future.delayed(const Duration(milliseconds: 220));

      final raw = text.trim();
      final norm = _normalizeForSearch(raw);

      bool ok = await _tryHighlightOnPage(raw, page);

      if (!ok && norm != raw) {
        ok = await _tryHighlightOnPage(norm, page);
      }

      if (!ok) {
        final longBase = norm.isNotEmpty ? norm : raw;

        final words = longBase
            .split(RegExp(r'\s+'))
            .where((w) => w.trim().isNotEmpty)
            .toList();

        String takeWords(int start, int count) {
          if (words.isEmpty) return '';
          start = start.clamp(0, words.length - 1);
          final end = (start + count).clamp(0, words.length);
          return words.sublist(start, end).join(' ');
        }

        final candidates = <String>[
          takeWords(0, 6),
          takeWords(2, 6),
          takeWords((words.length / 2).floor(), 6),
          takeWords(words.length - 8, 6),
        ].where((s) => s.trim().length >= 10).toList();

        for (final c in candidates) {
          ok = await _tryHighlightOnPage(c, page);
          if (ok) break;
        }
      }

      Future.delayed(duration, () {
        _searchResult?.clear();
      });
    } catch (_) {}
  }

  Future<void> _openNotes() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookmarkQuotePage(
          bookId: widget.bookId,
          title: widget.title,
        ),
      ),
    );

    if (result != null && result is Map) {
      final int page = (result['page'] as int?) ?? 1;
      final String text = (result['text'] as String?) ?? '';

      if (text.trim().isNotEmpty) {
        await _highlightForFewSeconds(text: text, page: page);
      }
    }
  }

  String? _buildFullPdfUrl(String? pdfUrl) {
    if (pdfUrl == null || pdfUrl.isEmpty) return null;
    if (pdfUrl.startsWith("http://") || pdfUrl.startsWith("https://")) return pdfUrl;
    return "${ApiEndpoints.serverUrl}$pdfUrl";
  }

  void _showSelectionSheet({
    required String text,
    required int page,
  }) {
    if (_sheetOpen) return;
    _sheetOpen = true;

    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(bookAccessViewModelProvider.notifier).addBookmark(
                  bookId: widget.bookId,
                  bookmark: BookmarkEntity(page: page, text: text),
                );
                Navigator.pop(context);
                SnackbarUtils.showSuccess(context, "Bookmark added");
              },
              child: const Text("Bookmark"),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(bookAccessViewModelProvider.notifier).addQuote(
                  bookId: widget.bookId,
                  quote: QuoteEntity(page: page, text: text),
                );
                Navigator.pop(context);
                SnackbarUtils.showSuccess(context, "Quote added");
              },
              child: const Text("Quote"),
            ),
            ElevatedButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: text));
                if (mounted) Navigator.pop(context);
              },
              child: const Text("Copy"),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      _sheetOpen = false;
    });
  }

  Future<String> _pdfCachePathForBook(String bookId) async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory("${dir.path}/cached_pdfs");
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    return "${folder.path}/book_$bookId.pdf";
  }

  Future<File?> _getCachedPdfFileIfExists() async {
    final path = await _pdfCachePathForBook(widget.bookId);
    final f = File(path);
    if (await f.exists()) return f;
    return null;
  }

  Future<File?> _downloadAndCachePdf(String url) async {
    try {
      final path = await _pdfCachePathForBook(widget.bookId);
      final f = File(path);
      final dio = Dio();

      final res = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          receiveTimeout: const Duration(seconds: 25),
          sendTimeout: const Duration(seconds: 25),
        ),
      );

      final bytes = res.data;
      if (bytes == null || bytes.isEmpty) {
        return null;
      }

      await f.writeAsBytes(bytes, flush: true);
      return f;
    } catch (e, st) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingAccess) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!_accessAllowed) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final state = ref.watch(bookAccessViewModelProvider);
    final access = state.bookAccess;
    final fullPdfUrl = _buildFullPdfUrl(access?.pdfUrl);

    if (access == null || fullPdfUrl == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: _openNotes,
          ),
        ],
      ),
      body: _pdfLoadError
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 64, color: Colors.black26),
              const SizedBox(height: 20),
              const Text(
                "PDF not available offline",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Connect to the internet once to cache this PDF.\nYour bookmarks and quotes are still available.",
                style: TextStyle(fontSize: 15, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _openNotes,
                icon: const Icon(Icons.bookmark_outline),
                label: const Text("View Bookmarks & Quotes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  if (!mounted) return;
                  setState(() => _pdfLoadError = false);
                },
                child: const Text("Try again"),
              ),
            ],
          ),
        ),
      )
          : FutureBuilder<File?>(
        future: _cachedPdfFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final cachedFile = snap.data;

          if (cachedFile != null) {
            return SfPdfViewer.file(
              cachedFile,
              controller: _controller,
              enableTextSelection: true,
              interactionMode: PdfInteractionMode.selection,
              canShowScrollHead: true,
              otherSearchTextHighlightColor: Colors.transparent,

              onDocumentLoaded: (_) {
                _docLoadedOnce = true;
                _restoreLastPositionOnce(access);
              },

              onDocumentLoadFailed: (details) {
                if (!mounted) return;
                setState(() => _pdfLoadError = true);
              },

              onPageChanged: (details) {
                if (_restoringNow) return;
                _saveLastPosition(
                  details.newPageNumber,
                  _controller.scrollOffset.dy,
                  _controller.zoomLevel,
                );
              },

              onTextSelectionChanged: (details) {
                final selected = details.selectedText;
                if (selected == null) return;

                final text = selected.trim();
                if (text.isEmpty) return;

                final page = _controller.pageNumber;
                _showSelectionSheet(text: text, page: page);
              },
            );
          }

          // no cached file -> try network
          return SfPdfViewer.network(
            fullPdfUrl,
            controller: _controller,
            enableTextSelection: true,
            interactionMode: PdfInteractionMode.selection,
            canShowScrollHead: true,
            otherSearchTextHighlightColor: Colors.transparent,

            onDocumentLoaded: (_) async {
              _docLoadedOnce = true;
              _restoreLastPositionOnce(access);

              final f = await _downloadAndCachePdf(fullPdfUrl);
              if (f != null && mounted) {
                setState(() {
                  _cachedPdfFuture = Future.value(f);
                });
              }
            },

            onDocumentLoadFailed: (details) {
              if (!mounted) return;
              setState(() => _pdfLoadError = true);
            },

            onPageChanged: (details) {
              if (_restoringNow) return;
              _saveLastPosition(
                details.newPageNumber,
                _controller.scrollOffset.dy,
                _controller.zoomLevel,
              );
            },

            onTextSelectionChanged: (details) {
              final selected = details.selectedText;
              if (selected == null) return;

              final text = selected.trim();
              if (text.isEmpty) return;

              final page = _controller.pageNumber;
              _showSelectionSheet(text: text, page: page);
            },
          );
        },
      ),
    );
  }
}



// import 'dart:async';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
//
// import 'package:smart_book_access/core/api/api_client.dart';
// import 'package:smart_book_access/core/api/api_endpoints.dart';
// import 'package:smart_book_access/core/services/hive/hive_service.dart';
// import 'package:smart_book_access/core/services/storage/token_service.dart';
// import 'package:smart_book_access/core/utils/snackbar_utils.dart';
//
// import 'package:smart_book_access/features/book/data/models/book_hive_model.dart';
// import 'package:smart_book_access/features/book/presentation/page/book_detail_page.dart';
//
// import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
// import 'package:smart_book_access/features/bookAccess/presentation/view_model/book_access_view_model.dart';
//
// import 'bookmark_quote_page.dart';
//
// class PdfReaderPage extends ConsumerStatefulWidget {
//   final String bookId;
//   final String title;
//
//   const PdfReaderPage({
//     super.key,
//     required this.bookId,
//     required this.title,
//   });
//
//   @override
//   ConsumerState<PdfReaderPage> createState() => _PdfReaderPageState();
// }
//
// class _PdfReaderPageState extends ConsumerState<PdfReaderPage> {
//   final PdfViewerController _controller = PdfViewerController();
//
//   Timer? _debounce;
//   PdfTextSearchResult? _searchResult;
//
//   bool _checkingAccess = true;
//   bool _accessAllowed = false;
//   bool _restoredOnce = false;
//   bool _sheetOpen = false;
//   bool _savingEnabled = false;
//   bool _docLoadedOnce = false;
//   bool _restoringNow = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final ok = await _verifyAccess();
//       if (!mounted) return;
//
//       if (!ok) {
//         _redirectToBookDetail();
//         return;
//       }
//
//       await ref.read(bookAccessViewModelProvider.notifier).fetchBookAccess(widget.bookId);
//       if (!mounted) return;
//
//       setState(() {
//         _checkingAccess = false;
//         _accessAllowed = true;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _debounce?.cancel();
//     _searchResult?.clear();
//     super.dispose();
//   }
//
//   Future<bool> _verifyAccess() async {
//     try {
//       final apiClient = ref.read(apiClientProvider);
//       final tokenService = ref.read(tokenServiceProvider);
//       final token = tokenService.getToken();
//
//       if (token == null || token.isEmpty) return false;
//
//       final res = await apiClient.get(
//         ApiEndpoints.getBookAccess(widget.bookId),
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );
//
//       if (res.data?['success'] != true) return false;
//
//       final data = res.data['data'] as Map<String, dynamic>?;
//       if (data == null) return false;
//
//       final isActive = data['isActive'];
//       if (isActive is bool && isActive == false) return false;
//
//       final expiresRaw = data['expiresAt'];
//       if (expiresRaw != null) {
//         final expiresAt = DateTime.tryParse(expiresRaw.toString());
//         if (expiresAt != null && !expiresAt.isAfter(DateTime.now())) {
//           return false;
//         }
//       }
//
//       final pdfUrl = data['pdfUrl'];
//       if (pdfUrl == null || pdfUrl.toString().trim().isEmpty) return false;
//
//       return true;
//     } catch (_) {
//       return false;
//     }
//   }
//
//   void _redirectToBookDetail() {
//     if (!mounted) return;
//
//     final hive = ref.read(hiveServiceProvider);
//     final BookHiveModel? cached = hive.getBookById(widget.bookId);
//
//     if (cached != null) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => BookDetailsPage(book: cached.toEntity()),
//         ),
//       );
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   void _saveLastPosition(int page, double offset, double zoomLevel) {
//     if (!_savingEnabled) return;
//     if (!_docLoadedOnce && page == 1 && offset <= 2) return;
//     final zoomPct = (zoomLevel * 100.0);
//
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 800), () {
//       ref.read(bookAccessViewModelProvider.notifier).updatePosition(
//         bookId: widget.bookId,
//         position: LastPositionEntity(
//           page: page,
//           offsetY: offset,
//           zoom: zoomPct,
//         ),
//       );
//     });
//   }
//
//   void _restoreLastPositionOnce(BookAccessEntity access) {
//     if (_restoredOnce) return;
//
//     final pos = access.lastPosition;
//     if (pos == null) {
//       _restoredOnce = true;
//       _savingEnabled = true;
//       return;
//     }
//
//     _restoredOnce = true;
//     _savingEnabled = false;
//     _restoringNow = true;
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       try {
//         _docLoadedOnce = true;
//         double zoomPct = (pos.zoom ?? 100.0);
//         if (zoomPct > 0 && zoomPct <= 3.0) {
//           zoomPct = zoomPct * 100.0;
//         }
//         final zoomLevel = (zoomPct / 100.0).clamp(0.7, 1.6);
//         _controller.zoomLevel = zoomLevel;
//         if (pos.page >= 1) {
//           _controller.jumpToPage(pos.page);
//         }
//
//         await Future.delayed(const Duration(milliseconds: 250));
//         if (pos.page >= 1) {
//           _controller.jumpToPage(pos.page);
//         }
//
//         await Future.delayed(const Duration(milliseconds: 700));
//       } catch (_) {
//         // ignore
//       } finally {
//         if (!mounted) return;
//         _restoringNow = false;
//         _savingEnabled = true;
//       }
//     });
//   }
//
//   String _normalizeForSearch(String s) {
//     var t = s;
//     t = t.replaceAll(RegExp(r'-\s*\n\s*'), '');
//     t = t.replaceAll(RegExp(r'\s+'), ' ').trim();
//
//     return t;
//   }
//
//   Future<bool> _tryHighlightOnPage(String query, int targetPage) async {
//     final q = query.trim();
//     if (q.isEmpty) return false;
//
//     _searchResult?.clear();
//     _searchResult = await _controller.searchText(q);
//
//     final total = _searchResult?.totalInstanceCount ?? 0;
//     if (total <= 0) return false;
//
//     for (int i = 0; i < total; i++) {
//       _searchResult?.nextInstance();
//       await Future.delayed(const Duration(milliseconds: 40));
//       if (_controller.pageNumber == targetPage) {
//         return true;
//       }
//     }
//
//     return true;
//   }
//
//   Future<void> _highlightForFewSeconds({
//     required String text,
//     required int page,
//     Duration duration = const Duration(seconds: 3),
//   }) async {
//     try {
//       _controller.jumpToPage(page);
//       await Future.delayed(const Duration(milliseconds: 220));
//
//       final raw = text.trim();
//       final norm = _normalizeForSearch(raw);
//
//       bool ok = await _tryHighlightOnPage(raw, page);
//
//       if (!ok && norm != raw) {
//         ok = await _tryHighlightOnPage(norm, page);
//       }
//
//       if (!ok) {
//         final longBase = norm.isNotEmpty ? norm : raw;
//
//         final words = longBase
//             .split(RegExp(r'\s+'))
//             .where((w) => w.trim().isNotEmpty)
//             .toList();
//
//         String takeWords(int start, int count) {
//           if (words.isEmpty) return '';
//           start = start.clamp(0, words.length - 1);
//           final end = (start + count).clamp(0, words.length);
//           return words.sublist(start, end).join(' ');
//         }
//
//         final candidates = <String>[
//           takeWords(0, 6),
//           takeWords(2, 6),
//           takeWords((words.length / 2).floor(), 6),
//           takeWords(words.length - 8, 6),
//         ].where((s) => s.trim().length >= 10).toList();
//
//         for (final c in candidates) {
//           ok = await _tryHighlightOnPage(c, page);
//           if (ok) break;
//         }
//       }
//
//       Future.delayed(duration, () {
//         _searchResult?.clear();
//       });
//     } catch (_) {}
//   }
//
//   Future<void> _openNotes() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => BookmarkQuotePage(
//           bookId: widget.bookId,
//           title: widget.title,
//         ),
//       ),
//     );
//
//     if (result != null && result is Map) {
//       final int page = (result['page'] as int?) ?? 1;
//       final String text = (result['text'] as String?) ?? '';
//
//       if (text.trim().isNotEmpty) {
//         await _highlightForFewSeconds(text: text, page: page);
//       }
//     }
//   }
//
//   String? _buildFullPdfUrl(String? pdfUrl) {
//     if (pdfUrl == null || pdfUrl.isEmpty) return null;
//     if (pdfUrl.startsWith("http://") || pdfUrl.startsWith("https://")) return pdfUrl;
//     return "${ApiEndpoints.serverUrl}$pdfUrl";
//   }
//
//   void _showSelectionSheet({
//     required String text,
//     required int page,
//   }) {
//     if (_sheetOpen) return;
//     _sheetOpen = true;
//
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => Container(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 ref.read(bookAccessViewModelProvider.notifier).addBookmark(
//                   bookId: widget.bookId,
//                   bookmark: BookmarkEntity(page: page, text: text),
//                 );
//                 Navigator.pop(context);
//                 SnackbarUtils.showSuccess(context, "Bookmark added");
//               },
//               child: const Text("Bookmark"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 ref.read(bookAccessViewModelProvider.notifier).addQuote(
//                   bookId: widget.bookId,
//                   quote: QuoteEntity(page: page, text: text),
//                 );
//                 Navigator.pop(context);
//                 SnackbarUtils.showSuccess(context, "Quote added");
//               },
//               child: const Text("Quote"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await Clipboard.setData(ClipboardData(text: text));
//                 if (mounted) Navigator.pop(context);
//               },
//               child: const Text("Copy"),
//             ),
//           ],
//         ),
//       ),
//     ).whenComplete(() {
//       _sheetOpen = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_checkingAccess) {
//       return const Scaffold(
//         backgroundColor: Colors.white,
//         body: SizedBox.shrink(),
//       );
//     }
//
//     if (!_accessAllowed) {
//       return const Scaffold(
//         backgroundColor: Colors.white,
//         body: SizedBox.shrink(),
//       );
//     }
//
//     final state = ref.watch(bookAccessViewModelProvider);
//     final access = state.bookAccess;
//     final fullPdfUrl = _buildFullPdfUrl(access?.pdfUrl);
//
//     if (access == null || fullPdfUrl == null) {
//       return const Scaffold(
//         backgroundColor: Colors.white,
//         body: SizedBox.shrink(),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           widget.title,
//           style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.menu, color: Colors.black),
//             onPressed: _openNotes,
//           ),
//         ],
//       ),
//       body: SfPdfViewer.network(
//         fullPdfUrl,
//         controller: _controller,
//
//         enableTextSelection: true,
//         interactionMode: PdfInteractionMode.selection,
//         canShowScrollHead: true,
//         otherSearchTextHighlightColor: Colors.transparent,
//
//         onDocumentLoaded: (_) {
//           _restoreLastPositionOnce(access);
//         },
//
//         onPageChanged: (details) {
//           if (_restoringNow) return;
//           _saveLastPosition(
//             details.newPageNumber,
//             _controller.scrollOffset.dy,
//             _controller.zoomLevel,
//           );
//         },
//
//         onTextSelectionChanged: (details) {
//           final selected = details.selectedText;
//           if (selected == null) return;
//
//           final text = selected.trim();
//           if (text.isEmpty) return;
//
//           final page = _controller.pageNumber;
//           _showSelectionSheet(text: text, page: page);
//         },
//       ),
//     );
//   }
// }