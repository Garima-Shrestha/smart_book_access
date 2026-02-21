// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_access_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookAccessApiModel _$BookAccessApiModelFromJson(Map<String, dynamic> json) =>
    BookAccessApiModel(
      id: json['_id'] as String?,
      user: json['user'],
      book: json['book'],
      pdfUrl: json['pdfUrl'] as String?,
      bookmarks: (json['bookmarks'] as List<dynamic>?)
          ?.map((e) => BookmarkApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      quotes: (json['quotes'] as List<dynamic>?)
          ?.map((e) => QuoteApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastPosition: json['lastPosition'] == null
          ? null
          : LastPositionApiModel.fromJson(
              json['lastPosition'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool?,
      rentedAt: json['rentedAt'] == null
          ? null
          : DateTime.parse(json['rentedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$BookAccessApiModelToJson(BookAccessApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user,
      'book': instance.book,
      'pdfUrl': instance.pdfUrl,
      'bookmarks': instance.bookmarks?.map((e) => e.toJson()).toList(),
      'quotes': instance.quotes?.map((e) => e.toJson()).toList(),
      'lastPosition': instance.lastPosition?.toJson(),
      'isActive': instance.isActive,
      'rentedAt': instance.rentedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

BookmarkApiModel _$BookmarkApiModelFromJson(Map<String, dynamic> json) =>
    BookmarkApiModel(
      page: (json['page'] as num).toInt(),
      text: json['text'] as String,
      selection: json['selection'] == null
          ? null
          : SelectionApiModel.fromJson(
              json['selection'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookmarkApiModelToJson(BookmarkApiModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'text': instance.text,
      'selection': instance.selection?.toJson(),
    };

QuoteApiModel _$QuoteApiModelFromJson(Map<String, dynamic> json) =>
    QuoteApiModel(
      page: (json['page'] as num).toInt(),
      text: json['text'] as String,
      selection: json['selection'] == null
          ? null
          : SelectionApiModel.fromJson(
              json['selection'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuoteApiModelToJson(QuoteApiModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'text': instance.text,
      'selection': instance.selection?.toJson(),
    };

SelectionApiModel _$SelectionApiModelFromJson(Map<String, dynamic> json) =>
    SelectionApiModel(
      start: (json['start'] as num).toInt(),
      end: (json['end'] as num).toInt(),
    );

Map<String, dynamic> _$SelectionApiModelToJson(SelectionApiModel instance) =>
    <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
    };

LastPositionApiModel _$LastPositionApiModelFromJson(
        Map<String, dynamic> json) =>
    LastPositionApiModel(
      page: (json['page'] as num).toInt(),
      offsetY: (json['offsetY'] as num).toDouble(),
      zoom: (json['zoom'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LastPositionApiModelToJson(
        LastPositionApiModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'offsetY': instance.offsetY,
      'zoom': instance.zoom,
    };
