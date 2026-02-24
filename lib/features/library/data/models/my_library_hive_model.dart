import 'package:hive/hive.dart';
import 'package:smart_book_access/core/constants/hive_table_constant.dart';
import 'package:smart_book_access/features/library/domain/entities/my_library_entity.dart';

part 'my_library_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.myLibraryTypeId)
class MyLibraryHiveModel extends HiveObject {
  @HiveField(0)
  final String accessId;
  @HiveField(1)
  final String bookId;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String author;
  @HiveField(4)
  final String? coverImageUrl;
  @HiveField(5)
  final int pages;
  @HiveField(6)
  final int progressPercent;
  @HiveField(7)
  final String timeLeftLabel;
  @HiveField(8, defaultValue: false)
  final bool isExpired;
  @HiveField(9, defaultValue: false)
  final bool isInactive;
  @HiveField(10, defaultValue: false)
  final bool canReRent;

  MyLibraryHiveModel({
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

  factory MyLibraryHiveModel.fromEntity(MyLibraryEntity entity) {
    return MyLibraryHiveModel(
      accessId: entity.accessId,
      bookId: entity.bookId,
      title: entity.title,
      author: entity.author,
      coverImageUrl: entity.coverImageUrl,
      pages: entity.pages,
      progressPercent: entity.progressPercent,
      timeLeftLabel: entity.timeLeftLabel,
      isExpired: entity.isExpired,
      isInactive: entity.isInactive,
      canReRent: entity.canReRent,
    );
  }

  MyLibraryEntity toEntity() {
    return MyLibraryEntity(
      accessId: accessId,
      bookId: bookId,
      title: title,
      author: author,
      coverImageUrl: coverImageUrl,
      pages: pages,
      progressPercent: progressPercent,
      timeLeftLabel: timeLeftLabel,
      isExpired: isExpired,
      isInactive: isInactive,
      canReRent: canReRent,
    );
  }

  static List<MyLibraryEntity> toEntityList(List<MyLibraryHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}