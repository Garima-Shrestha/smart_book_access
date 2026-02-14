import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String? bookId;
  final String title;
  final String author;
  final String description;
  final String genre;         // This is the Category ObjectId
  final int pages;
  final double price;
  final String publishedDate;
  final String coverImageUrl;

  const BookEntity({
    this.bookId,
    required this.title,
    required this.author,
    required this.description,
    required this.genre,
    required this.pages,
    required this.price,
    required this.publishedDate,
    required this.coverImageUrl,
  });

  @override
  List<Object?> get props => [bookId, title, author, description, genre, pages, price, publishedDate, coverImageUrl];
}