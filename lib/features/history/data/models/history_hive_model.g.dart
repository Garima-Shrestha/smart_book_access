// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryHiveModelAdapter extends TypeAdapter<HistoryHiveModel> {
  @override
  final int typeId = 3;

  @override
  HistoryHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryHiveModel(
      accessId: fields[0] as String?,
      bookId: fields[1] as String,
      title: fields[2] as String?,
      author: fields[3] as String?,
      coverImageUrl: fields[4] as String?,
      pages: fields[5] as int,
      genre: fields[6] as String?,
      rentedAt: fields[7] as DateTime?,
      expiresAt: fields[8] as DateTime?,
      isExpired: fields[9] == null ? false : fields[9] as bool,
      isInactive: fields[10] == null ? false : fields[10] as bool,
      canReRent: fields[11] == null ? false : fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryHiveModel obj) {
    writer
      ..writeByte(12)
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
      ..write(obj.genre)
      ..writeByte(7)
      ..write(obj.rentedAt)
      ..writeByte(8)
      ..write(obj.expiresAt)
      ..writeByte(9)
      ..write(obj.isExpired)
      ..writeByte(10)
      ..write(obj.isInactive)
      ..writeByte(11)
      ..write(obj.canReRent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
