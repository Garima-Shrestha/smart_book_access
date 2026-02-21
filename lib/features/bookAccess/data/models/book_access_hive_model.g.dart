// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_access_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAccessHiveModelAdapter extends TypeAdapter<BookAccessHiveModel> {
  @override
  final int typeId = 4;

  @override
  BookAccessHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookAccessHiveModel(
      id: fields[0] as String?,
      bookId: fields[1] as String,
      pdfUrl: fields[2] as String?,
      bookmarks: (fields[3] as List).cast<BookmarkHiveModel>(),
      quotes: (fields[4] as List).cast<QuoteHiveModel>(),
      lastPosition: fields[5] as LastPositionHiveModel?,
    );
  }

  @override
  void write(BinaryWriter writer, BookAccessHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bookId)
      ..writeByte(2)
      ..write(obj.pdfUrl)
      ..writeByte(3)
      ..write(obj.bookmarks)
      ..writeByte(4)
      ..write(obj.quotes)
      ..writeByte(5)
      ..write(obj.lastPosition);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAccessHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookmarkHiveModelAdapter extends TypeAdapter<BookmarkHiveModel> {
  @override
  final int typeId = 5;

  @override
  BookmarkHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookmarkHiveModel(
      page: fields[0] as int,
      text: fields[1] as String,
      selection: fields[2] as SelectionHiveModel?,
    );
  }

  @override
  void write(BinaryWriter writer, BookmarkHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.selection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuoteHiveModelAdapter extends TypeAdapter<QuoteHiveModel> {
  @override
  final int typeId = 6;

  @override
  QuoteHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuoteHiveModel(
      page: fields[0] as int,
      text: fields[1] as String,
      selection: fields[2] as SelectionHiveModel?,
    );
  }

  @override
  void write(BinaryWriter writer, QuoteHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.selection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SelectionHiveModelAdapter extends TypeAdapter<SelectionHiveModel> {
  @override
  final int typeId = 7;

  @override
  SelectionHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SelectionHiveModel(
      start: fields[0] as int,
      end: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SelectionHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectionHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LastPositionHiveModelAdapter extends TypeAdapter<LastPositionHiveModel> {
  @override
  final int typeId = 8;

  @override
  LastPositionHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LastPositionHiveModel(
      page: fields[0] as int,
      offsetY: fields[1] as double,
      zoom: fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, LastPositionHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.offsetY)
      ..writeByte(2)
      ..write(obj.zoom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LastPositionHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
