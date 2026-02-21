import 'package:equatable/equatable.dart';

class RentalEntity extends Equatable {
  final String? rentalId;
  final String userId;
  final String bookId;
  final String bookTitle;
  final String bookAuthor;
  final String bookImageUrl;
  final double price;
  final String expiresAt;
  final String? status;

  const RentalEntity({
    this.rentalId,
    required this.userId,
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookImageUrl,
    required this.price,
    required this.expiresAt,
    this.status,
  });

  @override
  List<Object?> get props => [
    rentalId,
    userId,
    bookId,
    bookTitle,
    bookAuthor,
    bookImageUrl,
    price,
    expiresAt,
    status,
  ];
}