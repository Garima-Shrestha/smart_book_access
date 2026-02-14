import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_book_access/core/constants/hive_table_constant.dart';
import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';
import 'package:uuid/uuid.dart';

part 'book_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.bookTypeId)
class BookHiveModel extends HiveObject {
  @HiveField(0)
  final String? bookId;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String author;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String genre; // Category ID
  @HiveField(5)
  final int pages;
  @HiveField(6)
  final double price;
  @HiveField(7)
  final String publishedDate;
  @HiveField(8)
  final String coverImageUrl;

  BookHiveModel({
    String? bookId,
    required this.title,
    required this.author,
    required this.description,
    required this.genre,
    required this.pages,
    required this.price,
    required this.publishedDate,
    required this.coverImageUrl,
  }) : bookId = bookId ?? const Uuid().v4();

  // From Entity
  factory BookHiveModel.fromEntity(BookEntity entity) {
    return BookHiveModel(
      bookId: entity.bookId,
      title: entity.title,
      author: entity.author,
      description: entity.description,
      genre: entity.genre,
      pages: entity.pages,
      price: entity.price,
      publishedDate: entity.publishedDate,
      coverImageUrl: entity.coverImageUrl,
    );
  }

  // To Entity
  BookEntity toEntity() {
    return BookEntity(
      bookId: bookId,
      title: title,
      author: author,
      description: description,
      genre: genre,
      pages: pages,
      price: price,
      publishedDate: publishedDate,
      coverImageUrl: coverImageUrl,
    );
  }

  // To Entity List
  static List<BookEntity> toEntityList(List<BookHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}