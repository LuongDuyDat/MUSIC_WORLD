import 'package:hive/hive.dart';
import 'package:music_world_app/repositories/album_repository/models/album.dart';
import 'package:music_world_app/repositories/playlist_repository/models/playlist.dart';

import '../../song_repository/models/song.dart';

part 'artist.g.dart';

@HiveType(typeId: 0)
class Artist extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final HiveList<Playlist> playlist;
  @HiveField(2)
  final HiveList<Song> song;
  @HiveField(3)
  final HiveList<Artist> follower;
  @HiveField(4)
  final HiveList<Artist> following;
  @HiveField(5)
  final String introduction;
  @HiveField(6)
  final String picture;
  @HiveField(7)
  final HiveList<Album> album;
  @HiveField(8)
  final String userName;
  @HiveField(9)
  final String password;
  @HiveField(10)
  final String email;
  @HiveField(11)
  final String phone;
  @HiveField(12)
  final String gender;
  @HiveField(13)
  final DateTime dob;
  @HiveField(14)
  late final HiveList<Song>? favorites;

  Artist({
    required this.name,
    required this.playlist,
    required this.song,
    required this.follower,
    required this.following,
    required this.introduction,
    required this.picture,
    required this.album,
    required this.userName,
    required this.password,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dob,
    this.favorites,
  });
}