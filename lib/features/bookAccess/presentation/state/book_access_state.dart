import 'package:equatable/equatable.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';

enum BookAccessStatus {
  initial,
  loading,
  loaded,
  updating,
  success,
  error
}

class BookAccessState extends Equatable {
  final BookAccessStatus status;
  final BookAccessEntity? bookAccess;
  final String? errorMessage;

  const BookAccessState({
    this.status = BookAccessStatus.initial,
    this.bookAccess,
    this.errorMessage,
  });

  BookAccessState copyWith({
    BookAccessStatus? status,
    BookAccessEntity? bookAccess,
    String? errorMessage,
  }) {
    return BookAccessState(
      status: status ?? this.status,
      bookAccess: bookAccess ?? this.bookAccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bookAccess, errorMessage];
}