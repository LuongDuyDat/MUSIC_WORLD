import 'package:equatable/equatable.dart';
import 'package:music_world_app/repositories/album_repository/models/album.dart';

import '../../../repositories/song_repository/models/song.dart';

enum HomeStatus {initial, loading, success, failure}

class HomeState extends Equatable {
  const HomeState({
    this.newAlbumStatus = HomeStatus.initial,
    this.recentSongStatus = HomeStatus.initial,
    this.newAlbums = const [],
    this.recentSongs = const [],
    this.hasMoreRecentSong = true,
  });

  final HomeStatus newAlbumStatus;
  final HomeStatus recentSongStatus;
  final List<Album> newAlbums;
  final List<Song> recentSongs;
  final bool hasMoreRecentSong;

  HomeState copyWith({
    HomeStatus Function()? newAlbumStatus,
    HomeStatus Function()? recentSongStatus,
    List<Album> Function()? newAlbums,
    List<Song> Function()? recentSongs,
    bool Function()? hasMoreRecentSong,
  }) {
    return HomeState(
      newAlbumStatus: newAlbumStatus != null ? newAlbumStatus() : this.newAlbumStatus,
      recentSongStatus: recentSongStatus != null ? recentSongStatus() : this.recentSongStatus,
      newAlbums: newAlbums != null ? newAlbums() : this.newAlbums,
      recentSongs: recentSongs != null ? recentSongs() : this.recentSongs,
      hasMoreRecentSong: hasMoreRecentSong != null ? hasMoreRecentSong() : this.hasMoreRecentSong,
    );
  }

  @override
  List<Object?> get props => [
    newAlbumStatus,
    recentSongStatus,
    newAlbums,
    recentSongs,
    hasMoreRecentSong,
  ];
}