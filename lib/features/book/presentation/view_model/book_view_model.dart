import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/features/book/domain/usecase/get_all_books_usecase.dart';
import 'package:smart_book_access/features/book/domain/usecase/get_book_by_id_usecase.dart';
import 'package:smart_book_access/features/book/domain/usecase/get_books_by_category_usecase.dart';
import 'package:smart_book_access/features/book/presentation/state/book_state.dart';

final bookViewModelProvider = NotifierProvider<BookViewModel, BookState>(
      () => BookViewModel(),
);

class BookViewModel extends Notifier<BookState> {
  late final GetAllBooksUsecase _getAllBooksUsecase;
  late final GetBookByIdUsecase _getBookByIdUsecase;
  late final GetBooksByCategoryUsecase _getBooksByCategoryUsecase;

  @override
  BookState build() {
    _getAllBooksUsecase = ref.read(getAllBooksUsecaseProvider);
    _getBookByIdUsecase = ref.read(getBookByIdUsecaseProvider);
    _getBooksByCategoryUsecase = ref.read(getBooksByCategoryUsecaseProvider);
    Future.microtask(() => getAllBooks());
    return const BookState();
  }

  Future<void> getAllBooks({String? searchTerm}) async {
    if (state.hasReachedMax && searchTerm == null) return;

    state = state.copyWith(status: BookStatus.loading);

    final params = GetAllBooksParams(
      page: state.page,
      size: 10,
      searchTerm: searchTerm,
    );

    final result = await _getAllBooksUsecase.call(params);

    result.fold(
          (failure) => state = state.copyWith(
        status: BookStatus.error,
        errorMessage: failure.message,
      ),
          (books) {
        if (books.isEmpty) {
          state = state.copyWith(
            status: BookStatus.success,
            hasReachedMax: true,
          );
        } else {
          state = state.copyWith(
            status: BookStatus.success,
            books: state.page == 1 ? books : [...state.books, ...books],
            page: state.page + 1,
            hasReachedMax: books.length < 10,
          );
        }
      },
    );
  }

  Future<void> getBooksByCategory(String categoryId) async {
    state = state.copyWith(status: BookStatus.loading, books: []);

    final result = await _getBooksByCategoryUsecase.call(categoryId);

    result.fold(
          (failure) => state = state.copyWith(
        status: BookStatus.error,
        errorMessage: failure.message,
      ),
          (books) => state = state.copyWith(
        status: BookStatus.success,
        books: books,
        hasReachedMax: true,
      ),
    );
  }

  Future<void> getBookById(String id) async {
    state = state.copyWith(status: BookStatus.loading);

    final result = await _getBookByIdUsecase.call(id);

    result.fold(
          (failure) => state = state.copyWith(
        status: BookStatus.error,
        errorMessage: failure.message,
      ),
          (book) => state = state.copyWith(
        status: BookStatus.success,
        selectedBook: book,
      ),
    );
  }

  Future<void> refreshBooks() async {
    state = state.copyWith(
      page: 1,
      hasReachedMax: false,
      books: [],
    );
    await getAllBooks();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
