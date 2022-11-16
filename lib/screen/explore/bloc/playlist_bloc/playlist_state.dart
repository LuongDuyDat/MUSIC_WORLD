import 'package:equatable/equatable.dart';

import '../../../../repositories/song_repository/models/song.dart';

enum PlaylistPageStatus {initial, loading, success, failure}

class PlaylistPageState extends Equatable {
  const PlaylistPageState({
    this.songStatus = PlaylistPageStatus.initial,
    this.songs = const [],
    this.hasMoreSong = true,
  });

  final PlaylistPageStatus songStatus;
  final List<Song> songs;
  final bool hasMoreSong;

  PlaylistPageState copyWith({
    PlaylistPageStatus Function()? songStatus,
    List<Song> Function()? songs,
    bool Function()? hasMoreSong,
  }) {
    return PlaylistPageState(
      songStatus: songStatus != null ? songStatus() : this.songStatus,
      songs: songs != null ? songs() : this.songs,
      hasMoreSong: hasMoreSong != null ? hasMoreSong() : this.hasMoreSong,
    );
  }

  @override
  List<Object?> get props => [
    songStatus,
    songs,
    hasMoreSong,
  ];
}