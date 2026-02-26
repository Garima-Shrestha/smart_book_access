// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryApiModel _$HistoryApiModelFromJson(Map<String, dynamic> json) =>
    HistoryApiModel(
      accessId: json['accessId'] as String?,
      bookId: json['bookId'] as String,
      title: json['title'] as String?,
      author: json['author'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      pages: (json['pages'] as num).toInt(),
      genre: json['genre'] as String?,
      rentedAt: json['rentedAt'] == null
          ? null
          : DateTime.parse(json['rentedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      isExpired: json['isExpired'] as bool,
      isInactive: json['isInactive'] as bool,
      canReRent: json['canReRent'] as bool,
    );

Map<String, dynamic> _$HistoryApiModelToJson(HistoryApiModel instance) =>
    <String, dynamic>{
      'accessId': instance.accessId,
      'bookId': instance.bookId,
      'title': instance.title,
      'author': instance.author,
      'coverImageUrl': instance.coverImageUrl,
      'pages': instance.pages,
      'genre': instance.genre,
      'rentedAt': instance.rentedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'isExpired': instance.isExpired,
      'isInactive': instance.isInactive,
      'canReRent': instance.canReRent,
    };
