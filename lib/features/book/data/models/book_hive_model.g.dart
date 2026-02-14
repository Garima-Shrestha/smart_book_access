// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookHiveModelAdapter extends TypeAdapter<BookHiveModel> {
  @override
  final int typeId = 2;

  @override
  BookHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookHiveModel(
      bookId: fields[0] as String?,
      title: fields[1] as String,
      author: fields[2] as String,
      description: fields[3] as String,
      genre: fields[4] as String,
      pages: fields[5] as int,
      price: fields[6] as double,
      publishedDate: fields[7] as String,
      coverImageUrl: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.bookId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.genre)
      ..writeByte(5)
      ..write(obj.pages)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.publishedDate)
      ..writeByte(8)
      ..write(obj.coverImageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
