import 'package:equatable/equatable.dart';
import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';

enum BookStatus {
  initial,
  loading,
  success,
  error,
}

class BookState extends Equatable {
  final BookStatus status;
  final List<BookEntity> books; 
  final BookEntity? selectedBook;
  final String? errorMessage;

  // For Pagination
  final int page;
  final bool hasReachedMax;

  const BookState({
    this.status = BookStatus.initial,
    this.books = const [],
    this.selectedBook,
    this.errorMessage,
    this.page = 1,
    this.hasReachedMax = false,
  });

  // copyWith method
  BookState copyWith({
    BookStatus? status,
    List<BookEntity>? books,
    BookEntity? selectedBook,
    String? errorMessage,
    int? page,
    bool? hasReachedMax,
  }) {
    return BookState(
      status: status ?? this.status,
      books: books ?? this.books,
      selectedBook: selectedBook ?? this.selectedBook,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    status,
    books,
    selectedBook,
    errorMessage,
    page,
    hasReachedMax
  ];
}