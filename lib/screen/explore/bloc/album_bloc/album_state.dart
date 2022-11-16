import 'package:equatable/equatable.dart';

import '../../../../repositories/song_repository/models/song.dart';

enum AlbumPageStatus {initial, loading, success, failure}

class AlbumPageState extends Equatable {
  const AlbumPageState({
    this.songStatus = AlbumPageStatus.initial,
    this.songs = const [],
    this.hasMoreSong = true,
  });

  final AlbumPageStatus songStatus;
  final List<Song> songs;
  final bool hasMoreSong;

  AlbumPageState copyWith({
    AlbumPageStatus Function()? songStatus,
    List<Song> Function()? songs,
    bool Function()? hasMoreSong,
  }) {
    return AlbumPageState(
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