import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:music_world_app/repositories/artist_repository/models/artist.dart';

part 'song.g.dart';

@HiveType(typeId: 2)
class Song extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final HiveList<Artist> artist;
  @HiveField(2)
  final String path;
  @HiveField(3)
  final String introduction;
  @HiveField(4)
  final String picture;
  @HiveField(5)
  final int listenNumber;
  @HiveField(6)
  final DateTime createAt;
  @HiveField(7)
  final String lyricPath;
  @HiveField(8)
  final Uint8List? image;
  @HiveField(9)
  final Uint8List? deviceSongPath;
  @HiveField(10)
  final Uint8List? deviceLyricPath;

  Song({
    required this.name,
    required this.artist,
    required this.path,
    required this.introduction,
    required this.picture,
    required this.listenNumber,
    required this.createAt,
    required this.lyricPath,
    this.image,
    this.deviceLyricPath,
    this.deviceSongPath,
  });
}