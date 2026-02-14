// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookApiModel _$BookApiModelFromJson(Map<String, dynamic> json) => BookApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      genre: BookApiModel._genreFromJson(json['genre']),
      pages: (json['pages'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      publishedDate: json['publishedDate'] as String,
      coverImageUrl: json['coverImageUrl'] as String,
    );

Map<String, dynamic> _$BookApiModelToJson(BookApiModel instance) =>
    <String, dynamic>{
      // '_id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'description': instance.description,
      'genre': BookApiModel._genreToJson(instance.genre),
      'pages': instance.pages,
      'price': instance.price,
      'publishedDate': instance.publishedDate,
      'coverImageUrl': instance.coverImageUrl,
    };
