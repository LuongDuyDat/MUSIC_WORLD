import 'package:hive/hive.dart';
import 'package:music_world_app/repositories/artist_repository/models/artist.dart';

import '../../song_repository/models/song.dart';

part 'playlist.g.dart';

@HiveType(typeId: 3)
class Playlist extends HiveObject{
  @HiveField(0)
  final String name;
  @HiveField(1)
  final HiveList<Artist> artist;
  @HiveField(2)
  final HiveList<Song> song;
  @HiveField(3)
  final String introduction;
  @HiveField(4)
  final String picture;

  Playlist({
    required this.name,
    required this.artist,
    required this.song,
    required this.introduction,
    required this.picture,
  });
}