import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:music_world_app/repositories/playlist_repository/models/playlist.dart';

import '../../repositories/album_repository/models/album.dart';
import '../../repositories/song_repository/models/song.dart';

enum HomeScreenStatus {initial, loading, success, failure}

List<Song> defaultList = [];

class HomeScreenState extends Equatable {
  const HomeScreenState({
    this.playingStatus = HomeScreenStatus.initial,
    this.isPlaying = false,
    this.playingSong = const [],
    this.playingAlbum,
    this.playingPlaylist,
  });

  final HomeScreenStatus playingStatus;
  final bool isPlaying;
  final List<Song> playingSong;
  final Playlist? playingPlaylist;
  final Album? playingAlbum;

  HomeScreenState copyWith({
    HomeScreenStatus Function()? playingStatus,
    bool Function()? isPlaying,
    List<Song> Function()? playingSong,
    Playlist Function()? playingPlaylist,
    Album Function()? playingAlbum,
  }) {
    return HomeScreenState(
      playingStatus: playingStatus != null ? playingStatus() : this.playingStatus,
      isPlaying: isPlaying != null ? isPlaying() : this.isPlaying,
      playingSong: playingSong != null ? playingSong() : this.playingSong,
      playingPlaylist: playingPlaylist != null ? playingPlaylist() : (playingAlbum != null ? null : this.playingPlaylist),
      playingAlbum: playingAlbum != null ? playingAlbum() : (playingPlaylist != null ? null : this.playingAlbum),
    );
  }

  @override
  List<Object?> get props => [
    playingStatus,
    isPlaying,
    playingSong,
    playingPlaylist,
    playingAlbum,
  ];
}