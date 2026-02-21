import 'package:equatable/equatable.dart';

class BookAccessEntity extends Equatable {
  final String? id;
  final String bookId;
  final String? pdfUrl;
  final List<BookmarkEntity> bookmarks;
  final List<QuoteEntity> quotes;
  final LastPositionEntity? lastPosition;

  const BookAccessEntity({
    this.id,
    required this.bookId,
    this.pdfUrl,
    this.bookmarks = const [],
    this.quotes = const [],
    this.lastPosition,
  });

  @override
  List<Object?> get props => [id, bookId, pdfUrl, bookmarks, quotes, lastPosition];
}

class BookmarkEntity extends Equatable {
  final int page;
  final String text;
  final SelectionEntity? selection;

  const BookmarkEntity({required this.page, required this.text, this.selection});

  @override
  List<Object?> get props => [page, text, selection];
}

class QuoteEntity extends Equatable {
  final int page;
  final String text;
  final SelectionEntity? selection;

  const QuoteEntity({required this.page, required this.text, this.selection});

  @override
  List<Object?> get props => [page, text, selection];
}

class SelectionEntity extends Equatable {
  final int start;
  final int end;

  const SelectionEntity({required this.start, required this.end});

  @override
  List<Object?> get props => [start, end];
}

class LastPositionEntity extends Equatable {
  final int page;
  final double offsetY;
  final double? zoom;

  const LastPositionEntity({required this.page, required this.offsetY, this.zoom});

  @override
  List<Object?> get props => [page, offsetY, zoom];
}