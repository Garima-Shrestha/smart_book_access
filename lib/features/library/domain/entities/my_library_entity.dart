import 'package:equatable/equatable.dart';

class MyLibraryEntity extends Equatable {
  final String accessId;
  final String bookId;

  final String title;
  final String author;
  final String? coverImageUrl;
  final int pages;
  final int progressPercent; // 0 - 100
  final String timeLeftLabel;
  final bool isExpired;
  final bool isInactive;
  final bool canReRent;

  const MyLibraryEntity({
    required this.accessId,
    required this.bookId,
    required this.title,
    required this.author,
    this.coverImageUrl,
    required this.pages,
    required this.progressPercent,
    required this.timeLeftLabel,
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
    progressPercent,
    timeLeftLabel,
    isExpired,
    isInactive,
    canReRent,
  ];
}