// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_library_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyLibraryApiModel _$MyLibraryApiModelFromJson(Map<String, dynamic> json) =>
    MyLibraryApiModel(
      accessId: json['accessId'] as String,
      bookId: json['bookId'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      coverImageUrl: json['coverImageUrl'] as String?,
      pages: (json['pages'] as num).toInt(),
      progressPercent: (json['progressPercent'] as num).toInt(),
      timeLeftLabel: json['timeLeftLabel'] as String,
      isExpired: json['isExpired'] as bool,
    );

Map<String, dynamic> _$MyLibraryApiModelToJson(MyLibraryApiModel instance) =>
    <String, dynamic>{
      'accessId': instance.accessId,
      'bookId': instance.bookId,
      'title': instance.title,
      'author': instance.author,
      'coverImageUrl': instance.coverImageUrl,
      'pages': instance.pages,
      'progressPercent': instance.progressPercent,
      'timeLeftLabel': instance.timeLeftLabel,
      'isExpired': instance.isExpired,
    };
