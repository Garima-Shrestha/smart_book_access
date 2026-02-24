import 'package:equatable/equatable.dart';
import 'package:smart_book_access/features/library/domain/entities/my_library_entity.dart';

enum MyLibraryStatus {
  initial,
  loading,
  loaded,
  error,
}

class MyLibraryState extends Equatable {
  final MyLibraryStatus status;
  final List<MyLibraryEntity> books;
  final String? errorMessage;

  const MyLibraryState({
    this.status = MyLibraryStatus.initial,
    this.books = const [],
    this.errorMessage,
  });

  MyLibraryState copyWith({
    MyLibraryStatus? status,
    List<MyLibraryEntity>? books,
    String? errorMessage,
  }) {
    return MyLibraryState(
      status: status ?? this.status,
      books: books ?? this.books,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, books, errorMessage];
}