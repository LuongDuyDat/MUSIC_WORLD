import 'package:equatable/equatable.dart';

import '../../../repositories/album_repository/models/album.dart';
import '../../../repositories/song_repository/models/song.dart';

enum SingerStatus {initial, loading, success, failure}

class SingerState extends Equatable {
  const SingerState({
    this.followingStatus = SingerStatus.initial,
    this.albums = const [],
    this.songs = const [],
    this.hasMoreSong = true,
    this.hasMoreAlbum = true,
    required this.isFollowing,
  });

  final SingerStatus followingStatus;
  final List<Album> albums;
  final List<Song> songs;
  final bool hasMoreSong;
  final bool hasMoreAlbum;
  final bool isFollowing;

  SingerState copyWith({
    SingerStatus Function()? followingStatus,
    List<Album> Function()? albums,
    List<Song> Function()? songs,
    bool Function()? hasMoreSong,
    bool Function()? hasMoreAlbum,
    bool Function()? isFollowing,
  }) {
    return SingerState(
      followingStatus: followingStatus != null ? followingStatus() : this.followingStatus,
      albums: albums != null ? albums() : this.albums,
      songs: songs != null ? songs() : this.songs,
      hasMoreSong: hasMoreSong != null ? hasMoreSong() : this.hasMoreSong,
      hasMoreAlbum: hasMoreAlbum != null ? hasMoreAlbum() : this.hasMoreAlbum,
      isFollowing: isFollowing != null ? isFollowing() : this.isFollowing,
    );
  }

  @override
  List<Object?> get props => [
    followingStatus,
    albums,
    songs,
    hasMoreSong,
    hasMoreAlbum,
    isFollowing,
  ];
}