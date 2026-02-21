import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/services/hive/hive_service.dart';
import 'package:smart_book_access/core/services/storage/user_session_service.dart';
import 'package:smart_book_access/features/bookAccess/data/datasources/book_access_datasource.dart';
import 'package:smart_book_access/features/bookAccess/data/models/book_access_hive_model.dart';

final bookAccessLocalDataSourceProvider = Provider<BookAccessLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return BookAccessLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class BookAccessLocalDatasource implements IBookAccessLocalDataSource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  BookAccessLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  })  : _hiveService = hiveService,
        _userSessionService = userSessionService;

  @override
  Future<BookAccessHiveModel?> getBookAccess(String bookId) async {
    try {
      final userId = _userSessionService.getCurrentUserId();
      if (userId == null) return null;

      final access = await _hiveService.getBookAccess(bookId);
      return access;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveBookAccess(BookAccessHiveModel model) async {
    try {
      final userId = _userSessionService.getCurrentUserId();
      if (userId == null) return;

      await _hiveService.saveBookAccess(model);
    } catch (e) {
      // Error handling
    }
  }

  @override
  Future<void> addBookmark(String bookId, BookmarkHiveModel bookmark) async {
    try {
      if (_userSessionService.getCurrentUserId() == null) return;

      final current = await _hiveService.getBookAccess(bookId);
      if (current != null) {
        current.bookmarks.add(bookmark);
        await _hiveService.saveBookAccess(current);
      }
    } catch (e) {}
  }

  @override
  Future<void> removeBookmark(String bookId, int index) async {
    try {
      if (_userSessionService.getCurrentUserId() == null) return;

      final current = await _hiveService.getBookAccess(bookId);
      if (current != null && current.bookmarks.length > index) {
        current.bookmarks.removeAt(index);
        await _hiveService.saveBookAccess(current);
      }
    } catch (e) {}
  }

  @override
  Future<void> addQuote(String bookId, QuoteHiveModel quote) async {
    try {
      if (_userSessionService.getCurrentUserId() == null) return;

      final current = await _hiveService.getBookAccess(bookId);
      if (current != null) {
        current.quotes.add(quote);
        await _hiveService.saveBookAccess(current);
      }
    } catch (e) {}
  }

  @override
  Future<void> removeQuote(String bookId, int index) async {
    try {
      if (_userSessionService.getCurrentUserId() == null) return;

      final current = await _hiveService.getBookAccess(bookId);
      if (current != null && current.quotes.length > index) {
        current.quotes.removeAt(index);
        await _hiveService.saveBookAccess(current);
      }
    } catch (e) {}
  }

  @override
  Future<void> updateLastPosition(String bookId, LastPositionHiveModel lastPosition) async {
    try {
      if (_userSessionService.getCurrentUserId() == null) return;

      final current = await _hiveService.getBookAccess(bookId);
      if (current != null) {
        final updated = BookAccessHiveModel(
          id: current.id,
          bookId: current.bookId,
          pdfUrl: current.pdfUrl,
          bookmarks: current.bookmarks,
          quotes: current.quotes,
          lastPosition: lastPosition,
        );
        await _hiveService.saveBookAccess(updated);
      }
    } catch (e) {}
  }

  @override
  Future<void> clearAll() async {
    try {
      await _hiveService.clearBookAccessBox();
    } catch (e) {}
  }
}