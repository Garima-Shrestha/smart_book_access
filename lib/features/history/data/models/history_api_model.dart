import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_book_access/features/history/domain/entities/history_entity.dart';

part 'history_api_model.g.dart';

@JsonSerializable()
class HistoryApiModel {
  @JsonKey(name: 'accessId')
  final String? accessId;

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

  HistoryApiModel({
    this.accessId,
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

  factory HistoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryApiModelToJson(this);

  // to entitiy
  HistoryEntity toEntity() {
    return HistoryEntity(
      accessId: accessId ?? '',
      bookId: bookId,
      title: title,
      author: author,
      coverImageUrl: coverImageUrl,
      pages: pages,
      genre: genre,
      rentedAt: rentedAt,
      expiresAt: expiresAt,
      isExpired: isExpired,
      isInactive: isInactive,
      canReRent: canReRent,
    );
  }

  // from entity
  factory HistoryApiModel.fromEntity(HistoryEntity entity) {
    return HistoryApiModel(
      accessId: entity.accessId,
      bookId: entity.bookId,
      title: entity.title,
      author: entity.author,
      coverImageUrl: entity.coverImageUrl,
      pages: entity.pages,
      genre: entity.genre,
      rentedAt: entity.rentedAt,
      expiresAt: entity.expiresAt,
      isExpired: entity.isExpired,
      isInactive: entity.isInactive,
      canReRent: entity.canReRent,
    );
  }

  // to entity list
  static List<HistoryEntity> toEntityList(List<HistoryApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}