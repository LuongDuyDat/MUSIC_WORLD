// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArtistAdapter extends TypeAdapter<Artist> {
  @override
  final int typeId = 0;

  @override
  Artist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Artist(
      name: fields[0] as String,
      playlist: (fields[1] as HiveList).castHiveList(),
      song: (fields[2] as HiveList).castHiveList(),
      follower: (fields[3] as HiveList).castHiveList(),
      following: (fields[4] as HiveList).castHiveList(),
      introduction: fields[5] as String,
      picture: fields[6] as String,
      album: (fields[7] as HiveList).castHiveList(),
      userName: fields[8] as String,
      password: fields[9] as String,
      email: fields[10] as String,
      phone: fields[11] as String,
      gender: fields[12] as String,
      dob: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Artist obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.playlist)
      ..writeByte(2)
      ..write(obj.song)
      ..writeByte(3)
      ..write(obj.follower)
      ..writeByte(4)
      ..write(obj.following)
      ..writeByte(5)
      ..write(obj.introduction)
      ..writeByte(6)
      ..write(obj.picture)
      ..writeByte(7)
      ..write(obj.album)
      ..writeByte(8)
      ..write(obj.userName)
      ..writeByte(9)
      ..write(obj.password)
      ..writeByte(10)
      ..write(obj.email)
      ..writeByte(11)
      ..write(obj.phone)
      ..writeByte(12)
      ..write(obj.gender)
      ..writeByte(13)
      ..write(obj.dob);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
