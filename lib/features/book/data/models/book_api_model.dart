import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';

part 'book_api_model.g.dart';

@JsonSerializable()
class BookApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String author;
  final String description;
  @JsonKey(fromJson: _genreFromJson, toJson: _genreToJson)
  final String genre; // Stores the Category ObjectId
  final int pages;
  final double price;
  final String publishedDate;
  final String coverImageUrl;

  BookApiModel({
    this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.genre,
    required this.pages,
    required this.price,
    required this.publishedDate,
    required this.coverImageUrl,
  });

  factory BookApiModel.fromJson(Map<String, dynamic> json) =>
      _$BookApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookApiModelToJson(this);


  static String _genreFromJson(dynamic value) {
    if (value is String) return value;
    if (value is Map<String, dynamic>) return value['_id']?.toString() ?? '';
    return '';
  }

  static dynamic _genreToJson(String value) => value;

  // toEntity
  BookEntity toEntity() {
    return BookEntity(
      bookId: id,
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

  // fromEntity
  factory BookApiModel.fromEntity(BookEntity entity) {
    return BookApiModel(
      id: entity.bookId,
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

  // toEntityList
  static List<BookEntity> toEntityList(List<BookApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}