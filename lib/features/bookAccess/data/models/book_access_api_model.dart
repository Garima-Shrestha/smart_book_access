import 'package:json_annotation/json_annotation.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';

part 'book_access_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BookAccessApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final dynamic user;
  final dynamic book;
  final String? pdfUrl;
  final List<BookmarkApiModel>? bookmarks;
  final List<QuoteApiModel>? quotes;
  final LastPositionApiModel? lastPosition;
  final bool? isActive;
  final DateTime? rentedAt;
  final DateTime? expiresAt;

  const BookAccessApiModel({
    this.id,
    required this.user,
    required this.book,
    this.pdfUrl,
    this.bookmarks,
    this.quotes,
    this.lastPosition,
    this.isActive,
    this.rentedAt,
    this.expiresAt,
  });

  factory BookAccessApiModel.fromJson(Map<String, dynamic> json) =>
      _$BookAccessApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookAccessApiModelToJson(this);

  String _extractId(dynamic v) {
    if (v == null) return '';
    if (v is String) return v;
    if (v is Map<String, dynamic>) {
      return (v['_id'] ?? v['id'] ?? '').toString();
    }
    return v.toString();
  }

  BookAccessEntity toEntity() {
    return BookAccessEntity(
      id: id,
      bookId: _extractId(book),
      pdfUrl: pdfUrl,
      bookmarks: bookmarks?.map((e) => e.toEntity()).toList() ?? const [],
      quotes: quotes?.map((e) => e.toEntity()).toList() ?? const [],
      lastPosition: lastPosition?.toEntity(),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class BookmarkApiModel {
  final int page;
  final String text;
  final SelectionApiModel? selection;

  const BookmarkApiModel({
    required this.page,
    required this.text,
    this.selection,
  });

  factory BookmarkApiModel.fromJson(Map<String, dynamic> json) =>
      _$BookmarkApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkApiModelToJson(this);

  BookmarkEntity toEntity() =>
      BookmarkEntity(page: page, text: text, selection: selection?.toEntity());

  factory BookmarkApiModel.fromEntity(BookmarkEntity entity) => BookmarkApiModel(
    page: entity.page,
    text: entity.text,
    selection: entity.selection != null
        ? SelectionApiModel.fromEntity(entity.selection!)
        : null,
  );
}

@JsonSerializable(explicitToJson: true)
class QuoteApiModel {
  final int page;
  final String text;
  final SelectionApiModel? selection;

  const QuoteApiModel({
    required this.page,
    required this.text,
    this.selection,
  });

  factory QuoteApiModel.fromJson(Map<String, dynamic> json) =>
      _$QuoteApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteApiModelToJson(this);

  QuoteEntity toEntity() =>
      QuoteEntity(page: page, text: text, selection: selection?.toEntity());

  factory QuoteApiModel.fromEntity(QuoteEntity entity) => QuoteApiModel(
    page: entity.page,
    text: entity.text,
    selection: entity.selection != null
        ? SelectionApiModel.fromEntity(entity.selection!)
        : null,
  );
}

@JsonSerializable()
class SelectionApiModel {
  final int start;
  final int end;

  const SelectionApiModel({required this.start, required this.end});

  factory SelectionApiModel.fromJson(Map<String, dynamic> json) =>
      _$SelectionApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SelectionApiModelToJson(this);

  SelectionEntity toEntity() => SelectionEntity(start: start, end: end);

  factory SelectionApiModel.fromEntity(SelectionEntity entity) =>
      SelectionApiModel(start: entity.start, end: entity.end);
}

@JsonSerializable()
class LastPositionApiModel {
  final int page;
  final double offsetY;
  final double? zoom;

  const LastPositionApiModel({
    required this.page,
    required this.offsetY,
    this.zoom,
  });

  factory LastPositionApiModel.fromJson(Map<String, dynamic> json) =>
      _$LastPositionApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$LastPositionApiModelToJson(this);

  LastPositionEntity toEntity() =>
      LastPositionEntity(page: page, offsetY: offsetY, zoom: zoom);

  factory LastPositionApiModel.fromEntity(LastPositionEntity entity) =>
      LastPositionApiModel(page: entity.page, offsetY: entity.offsetY, zoom: entity.zoom);
}