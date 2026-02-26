import 'package:hive/hive.dart';
import 'package:smart_book_access/core/constants/hive_table_constant.dart';
import 'package:smart_book_access/features/history/domain/entities/history_entity.dart';
import 'package:uuid/uuid.dart';

part 'history_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.rentalTypeId)
class HistoryHiveModel extends HiveObject {

  @HiveField(0)
  final String accessId;
  @HiveField(1)
  final String bookId;
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final String? author;
  @HiveField(4)
  final String? coverImageUrl;
  @HiveField(5)
  final int pages;
  @HiveField(6)
  final String? genre;
  @HiveField(7)
  final DateTime? rentedAt;
  @HiveField(8)
  final DateTime? expiresAt;
  @HiveField(9, defaultValue: false)
  final bool isExpired;
  @HiveField(10, defaultValue: false)
  final bool isInactive;
  @HiveField(11, defaultValue: false)
  final bool canReRent;

  // Constructor
  HistoryHiveModel({
    String? accessId,
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
  }) : accessId = accessId ?? const Uuid().v4();

  // From Entity
  factory HistoryHiveModel.fromEntity(HistoryEntity entity) {
    return HistoryHiveModel(
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

  // To Entity
  HistoryEntity toEntity() {
    return HistoryEntity(
      accessId: accessId,
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

  // ToEntityList
  static List<HistoryEntity> toEntityList(List<HistoryHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}