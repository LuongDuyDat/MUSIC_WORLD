// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongAdapter extends TypeAdapter<Song> {
  @override
  final int typeId = 2;

  @override
  Song read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Song(
      name: fields[0] as String,
      artist: (fields[1] as HiveList).castHiveList(),
      path: fields[2] as String,
      introduction: fields[3] as String,
      picture: fields[4] as String,
      listenNumber: fields[5] as int,
      createAt: fields[6] as DateTime,
      lyricPath: fields[7] as String,
      image: fields[8] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, Song obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.artist)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.introduction)
      ..writeByte(4)
      ..write(obj.picture)
      ..writeByte(5)
      ..write(obj.listenNumber)
      ..writeByte(6)
      ..write(obj.createAt)
      ..writeByte(7)
      ..write(obj.lyricPath)
      ..writeByte(8)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
