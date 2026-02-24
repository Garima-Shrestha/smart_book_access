import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_book_access/features/library/domain/entities/my_library_entity.dart';

part 'my_library_api_model.g.dart';

@JsonSerializable()
class MyLibraryApiModel {
  final String accessId;
  final String bookId;

  final String title;
  final String author;
  final String? coverImageUrl;
  final int pages;
  final int progressPercent; // 0 - 100
  final String timeLeftLabel;
  final bool isExpired;

  MyLibraryApiModel({
    required this.accessId,
    required this.bookId,
    required this.title,
    required this.author,
    this.coverImageUrl,
    required this.pages,
    required this.progressPercent,
    required this.timeLeftLabel,
    required this.isExpired,
  });

  factory MyLibraryApiModel.fromJson(Map<String, dynamic> json) =>
      _$MyLibraryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyLibraryApiModelToJson(this);

  // toEntity
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
    );
  }

  // fromEntity
  factory MyLibraryApiModel.fromEntity(MyLibraryEntity entity) {
    return MyLibraryApiModel(
      accessId: entity.accessId,
      bookId: entity.bookId,
      title: entity.title,
      author: entity.author,
      coverImageUrl: entity.coverImageUrl,
      pages: entity.pages,
      progressPercent: entity.progressPercent,
      timeLeftLabel: entity.timeLeftLabel,
      isExpired: entity.isExpired,
    );
  }

  // toEntityList
  static List<MyLibraryEntity> toEntityList(List<MyLibraryApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}