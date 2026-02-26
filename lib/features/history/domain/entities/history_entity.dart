import 'package:equatable/equatable.dart';

class HistoryEntity extends Equatable {
  final String accessId;
  final String bookId;

  final String? title;
  final String? author;
  final String? coverImageUrl;
  final int pages;
  final String? genre;

  final DateTime? rentedAt;
  final DateTime? expiresAt;

  final bool isExpired;
  final bool isInactive;
  final bool canReRent;

  const HistoryEntity({
    required this.accessId,
    required this.bookId,
    this.title,
    this.author,
    this.coverImageUrl,
    required this.pages,
    this.genre,
    this.rentedAt,
    this.expiresAt,
    required this.isExpired,
    required this.isInactive,
    required this.canReRent,
  });

  @override
  List<Object?> get props => [
    accessId,
    bookId,
    title,
    author,
    coverImageUrl,
    pages,
    genre,
    rentedAt,
    expiresAt,
    isExpired,
    isInactive,
    canReRent,
  ];
}