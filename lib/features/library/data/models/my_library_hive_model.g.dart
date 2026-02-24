// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_library_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyLibraryHiveModelAdapter extends TypeAdapter<MyLibraryHiveModel> {
  @override
  final int typeId = 9;

  @override
  MyLibraryHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyLibraryHiveModel(
      accessId: fields[0] as String,
      bookId: fields[1] as String,
      title: fields[2] as String,
      author: fields[3] as String,
      coverImageUrl: fields[4] as String?,
      pages: fields[5] as int,
      progressPercent: fields[6] as int,
      timeLeftLabel: fields[7] as String,
      isExpired: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MyLibraryHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.accessId)
      ..writeByte(1)
      ..write(obj.bookId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.author)
      ..writeByte(4)
      ..write(obj.coverImageUrl)
      ..writeByte(5)
      ..write(obj.pages)
      ..writeByte(6)
      ..write(obj.progressPercent)
      ..writeByte(7)
      ..write(obj.timeLeftLabel)
      ..writeByte(8)
      ..write(obj.isExpired);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyLibraryHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
