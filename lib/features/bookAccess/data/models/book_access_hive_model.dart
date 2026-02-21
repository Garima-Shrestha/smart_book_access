import 'package:hive/hive.dart';
import 'package:smart_book_access/core/constants/hive_table_constant.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';

part 'book_access_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.bookAccessTypeId)
class BookAccessHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String bookId;
  @HiveField(2)
  final String? pdfUrl;
  @HiveField(3)
  final List<BookmarkHiveModel> bookmarks;
  @HiveField(4)
  final List<QuoteHiveModel> quotes;
  @HiveField(5)
  final LastPositionHiveModel? lastPosition;

  BookAccessHiveModel({
    this.id,
    required this.bookId,
    this.pdfUrl,
    this.bookmarks = const [],
    this.quotes = const [],
    this.lastPosition,
  });

  // From Entity
  factory BookAccessHiveModel.fromEntity(BookAccessEntity entity) {
    return BookAccessHiveModel(
      id: entity.id,
      bookId: entity.bookId,
      pdfUrl: entity.pdfUrl,
      bookmarks: entity.bookmarks.map((e) => BookmarkHiveModel.fromEntity(e)).toList(),
      quotes: entity.quotes.map((e) => QuoteHiveModel.fromEntity(e)).toList(),
      lastPosition: entity.lastPosition != null
          ? LastPositionHiveModel.fromEntity(entity.lastPosition!)
          : null,
    );
  }

  // To Entity
  BookAccessEntity toEntity() {
    return BookAccessEntity(
      id: id,
      bookId: bookId,
      pdfUrl: pdfUrl,
      bookmarks: bookmarks.map((e) => e.toEntity()).toList(),
      quotes: quotes.map((e) => e.toEntity()).toList(),
      lastPosition: lastPosition?.toEntity(),
    );
  }
}


@HiveType(typeId: HiveTableConstant.bookmarkTypeId)
class BookmarkHiveModel {
  @HiveField(0)
  final int page;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final SelectionHiveModel? selection;

  BookmarkHiveModel({required this.page, required this.text, this.selection});

  factory BookmarkHiveModel.fromEntity(BookmarkEntity entity) => BookmarkHiveModel(
    page: entity.page,
    text: entity.text,
    selection: entity.selection != null ? SelectionHiveModel.fromEntity(entity.selection!) : null,
  );

  BookmarkEntity toEntity() => BookmarkEntity(page: page, text: text, selection: selection?.toEntity());
}

@HiveType(typeId: HiveTableConstant.quoteTypeId)
class QuoteHiveModel {
  @HiveField(0)
  final int page;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final SelectionHiveModel? selection;

  QuoteHiveModel({required this.page, required this.text, this.selection});

  factory QuoteHiveModel.fromEntity(QuoteEntity entity) => QuoteHiveModel(
    page: entity.page,
    text: entity.text,
    selection: entity.selection != null ? SelectionHiveModel.fromEntity(entity.selection!) : null,
  );

  QuoteEntity toEntity() => QuoteEntity(page: page, text: text, selection: selection?.toEntity());
}

@HiveType(typeId: HiveTableConstant.selectionTypeId)
class SelectionHiveModel {
  @HiveField(0)
  final int start;
  @HiveField(1)
  final int end;

  SelectionHiveModel({required this.start, required this.end});

  factory SelectionHiveModel.fromEntity(SelectionEntity entity) => SelectionHiveModel(start: entity.start, end: entity.end);
  SelectionEntity toEntity() => SelectionEntity(start: start, end: end);
}

@HiveType(typeId: HiveTableConstant.lastPositionTypeId)
class LastPositionHiveModel {
  @HiveField(0)
  final int page;
  @HiveField(1)
  final double offsetY;
  @HiveField(2)
  final double? zoom;

  LastPositionHiveModel({required this.page, required this.offsetY, this.zoom});

  factory LastPositionHiveModel.fromEntity(LastPositionEntity entity) => LastPositionHiveModel(page: entity.page, offsetY: entity.offsetY, zoom: entity.zoom);
  LastPositionEntity toEntity() => LastPositionEntity(page: page, offsetY: offsetY, zoom: zoom);
}