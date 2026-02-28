import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/services/hive/hive_service.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/add_bookmark_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/add_quote_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/get_book_access_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/remove_bookmark_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/remove_quote_usecase.dart';
import 'package:smart_book_access/features/bookAccess/domain/usecase/update_last_position_usecase.dart';
import 'package:smart_book_access/features/bookAccess/presentation/state/book_access_state.dart';

final bookAccessViewModelProvider = NotifierProvider<BookAccessViewModel, BookAccessState>(
      () => BookAccessViewModel(),
);

class BookAccessViewModel extends Notifier<BookAccessState> {
  late final GetBookAccessUsecase _getBookAccessUsecase;
  late final AddBookmarkUsecase _addBookmarkUsecase;
  late final RemoveBookmarkUsecase _removeBookmarkUsecase;
  late final AddQuoteUsecase _addQuoteUsecase;
  late final RemoveQuoteUsecase _removeQuoteUsecase;
  late final UpdateLastPositionUsecase _updateLastPositionUsecase;

  @override
  BookAccessState build() {
    _getBookAccessUsecase = ref.read(getBookAccessUsecaseProvider);
    _addBookmarkUsecase = ref.read(addBookmarkUsecaseProvider);
    _removeBookmarkUsecase = ref.read(removeBookmarkUsecaseProvider);
    _addQuoteUsecase = ref.read(addQuoteUsecaseProvider);
    _removeQuoteUsecase = ref.read(removeQuoteUsecaseProvider);
    _updateLastPositionUsecase = ref.read(updateLastPositionUsecaseProvider);

    return const BookAccessState();
  }

  // Fetch Book Access Data
  Future<void> fetchBookAccess(String bookId) async {
    state = state.copyWith(status: BookAccessStatus.loading);

    final result = await _getBookAccessUsecase.call(bookId);

    result.fold(
          (failure) => state = state.copyWith(
        status: BookAccessStatus.error,
        errorMessage: failure.message,
      ),
          (bookAccess) => state = state.copyWith(
        status: BookAccessStatus.loaded,
        bookAccess: bookAccess,
      ),
    );
  }

  // Add Bookmark
  Future<void> addBookmark({
    required String bookId,
    required BookmarkEntity bookmark,
  }) async {
    state = state.copyWith(status: BookAccessStatus.updating);

    final params = BookmarkParams(bookId: bookId, bookmark: bookmark);
    final result = await _addBookmarkUsecase.call(params);

    result.fold(
          (failure) => state = state.copyWith(
        status: BookAccessStatus.error,
        errorMessage: failure.message,
      ),
          (updatedAccess) => state = state.copyWith(
        status: BookAccessStatus.success,
        bookAccess: updatedAccess,
      ),
    );
  }

  // Remove Bookmark
  Future<void> removeBookmark(String bookId, int index) async {
    state = state.copyWith(status: BookAccessStatus.updating);

    final result = await _removeBookmarkUsecase.call(
      RemoveBookmarkParams(bookId: bookId, index: index),
    );

    result.fold(
          (failure) => state = state.copyWith(
        status: BookAccessStatus.error,
        errorMessage: failure.message,
      ),
          (updatedAccess) => state = state.copyWith(
        status: BookAccessStatus.success,
        bookAccess: updatedAccess,
      ),
    );
  }

  // Add Quote
  Future<void> addQuote({
    required String bookId,
    required QuoteEntity quote,
  }) async {
    state = state.copyWith(status: BookAccessStatus.updating);

    final params = QuoteParams(bookId: bookId, quote: quote);
    final result = await _addQuoteUsecase.call(params);

    result.fold(
          (failure) => state = state.copyWith(
        status: BookAccessStatus.error,
        errorMessage: failure.message,
      ),
          (updatedAccess) => state = state.copyWith(
        status: BookAccessStatus.success,
        bookAccess: updatedAccess,
      ),
    );
  }

  // Remove Quote
  Future<void> removeQuote(String bookId, int index) async {
    state = state.copyWith(status: BookAccessStatus.updating);

    final result = await _removeQuoteUsecase.call(
      RemoveQuoteParams(bookId: bookId, index: index),
    );

    result.fold(
          (failure) => state = state.copyWith(
        status: BookAccessStatus.error,
        errorMessage: failure.message,
      ),
          (updatedAccess) => state = state.copyWith(
        status: BookAccessStatus.success,
        bookAccess: updatedAccess,
      ),
    );
  }

  // Update Last Position
  Future<void> updatePosition({
    required String bookId,
    required LastPositionEntity position,
  }) async {
    final params = PositionParams(bookId: bookId, position: position);
    final result = await _updateLastPositionUsecase.call(params);

    result.fold(
          (failure) => state = state.copyWith(
        status: BookAccessStatus.error,
        errorMessage: failure.message,
      ),
          (updatedAccess) => state = state.copyWith(
        bookAccess: updatedAccess,
      ),
    );
  }

  Future<void> fetchBookAccessFromCache(String bookId) async {
    try {
      final hive = ref.read(hiveServiceProvider);
      final cached = await hive.getBookAccess(bookId);
      if (cached != null) {
        state = state.copyWith(
          status: BookAccessStatus.loaded,
          bookAccess: cached.toEntity(),
        );
      }
    } catch (_) {}
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}



// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
// import 'package:smart_book_access/features/bookAccess/domain/usecase/add_bookmark_usecase.dart';
// import 'package:smart_book_access/features/bookAccess/domain/usecase/add_quote_usecase.dart';
// import 'package:smart_book_access/features/bookAccess/domain/usecase/get_book_access_usecase.dart';
// import 'package:smart_book_access/features/bookAccess/domain/usecase/remove_bookmark_usecase.dart';
// import 'package:smart_book_access/features/bookAccess/domain/usecase/remove_quote_usecase.dart';
// import 'package:smart_book_access/features/bookAccess/domain/usecase/update_last_position_usecase.dart';
// import 'package:smart_book_access/features/bookAccess/presentation/state/book_access_state.dart';
//
// final bookAccessViewModelProvider = NotifierProvider<BookAccessViewModel, BookAccessState>(
//       () => BookAccessViewModel(),
// );
//
// class BookAccessViewModel extends Notifier<BookAccessState> {
//   late final GetBookAccessUsecase _getBookAccessUsecase;
//   late final AddBookmarkUsecase _addBookmarkUsecase;
//   late final RemoveBookmarkUsecase _removeBookmarkUsecase;
//   late final AddQuoteUsecase _addQuoteUsecase;
//   late final RemoveQuoteUsecase _removeQuoteUsecase;
//   late final UpdateLastPositionUsecase _updateLastPositionUsecase;
//
//   @override
//   BookAccessState build() {
//     _getBookAccessUsecase = ref.read(getBookAccessUsecaseProvider);
//     _addBookmarkUsecase = ref.read(addBookmarkUsecaseProvider);
//     _removeBookmarkUsecase = ref.read(removeBookmarkUsecaseProvider);
//     _addQuoteUsecase = ref.read(addQuoteUsecaseProvider);
//     _removeQuoteUsecase = ref.read(removeQuoteUsecaseProvider);
//     _updateLastPositionUsecase = ref.read(updateLastPositionUsecaseProvider);
//
//     return const BookAccessState();
//   }
//
//   // Fetch Book Access Data
//   Future<void> fetchBookAccess(String bookId) async {
//     state = state.copyWith(status: BookAccessStatus.loading);
//
//     final result = await _getBookAccessUsecase.call(bookId);
//
//     result.fold(
//           (failure) => state = state.copyWith(
//         status: BookAccessStatus.error,
//         errorMessage: failure.message,
//       ),
//           (bookAccess) => state = state.copyWith(
//         status: BookAccessStatus.loaded,
//         bookAccess: bookAccess,
//       ),
//     );
//   }
//
//   // Add Bookmark
//   Future<void> addBookmark({
//     required String bookId,
//     required BookmarkEntity bookmark,
//   }) async {
//     state = state.copyWith(status: BookAccessStatus.updating);
//
//     final params = BookmarkParams(bookId: bookId, bookmark: bookmark);
//     final result = await _addBookmarkUsecase.call(params);
//
//     result.fold(
//           (failure) => state = state.copyWith(
//         status: BookAccessStatus.error,
//         errorMessage: failure.message,
//       ),
//           (updatedAccess) => state = state.copyWith(
//         status: BookAccessStatus.success,
//         bookAccess: updatedAccess,
//       ),
//     );
//   }
//
//   // Remove Bookmark
//   Future<void> removeBookmark(String bookId, int index) async {
//     state = state.copyWith(status: BookAccessStatus.updating);
//
//     final result = await _removeBookmarkUsecase.call(
//       RemoveBookmarkParams(bookId: bookId, index: index),
//     );
//
//     result.fold(
//           (failure) => state = state.copyWith(
//         status: BookAccessStatus.error,
//         errorMessage: failure.message,
//       ),
//           (updatedAccess) => state = state.copyWith(
//         status: BookAccessStatus.success,
//         bookAccess: updatedAccess,
//       ),
//     );
//   }
//
//   // Add Quote
//   Future<void> addQuote({
//     required String bookId,
//     required QuoteEntity quote,
//   }) async {
//     state = state.copyWith(status: BookAccessStatus.updating);
//
//     final params = QuoteParams(bookId: bookId, quote: quote);
//     final result = await _addQuoteUsecase.call(params);
//
//     result.fold(
//           (failure) => state = state.copyWith(
//         status: BookAccessStatus.error,
//         errorMessage: failure.message,
//       ),
//           (updatedAccess) => state = state.copyWith(
//         status: BookAccessStatus.success,
//         bookAccess: updatedAccess,
//       ),
//     );
//   }
//
//   // Remove Quote
//   Future<void> removeQuote(String bookId, int index) async {
//     state = state.copyWith(status: BookAccessStatus.updating);
//
//     final result = await _removeQuoteUsecase.call(
//       RemoveQuoteParams(bookId: bookId, index: index),
//     );
//
//     result.fold(
//           (failure) => state = state.copyWith(
//         status: BookAccessStatus.error,
//         errorMessage: failure.message,
//       ),
//           (updatedAccess) => state = state.copyWith(
//         status: BookAccessStatus.success,
//         bookAccess: updatedAccess,
//       ),
//     );
//   }
//
//   // Update Last Position
//   Future<void> updatePosition({
//     required String bookId,
//     required LastPositionEntity position,
//   }) async {
//     final params = PositionParams(bookId: bookId, position: position);
//     final result = await _updateLastPositionUsecase.call(params);
//
//     result.fold(
//           (failure) => state = state.copyWith(
//         status: BookAccessStatus.error,
//         errorMessage: failure.message,
//       ),
//           (updatedAccess) => state = state.copyWith(
//         bookAccess: updatedAccess,
//       ),
//     );
//   }
//
//   void clearError() {
//     state = state.copyWith(errorMessage: null);
//   }
// }