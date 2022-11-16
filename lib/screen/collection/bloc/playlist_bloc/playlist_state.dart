import 'package:equatable/equatable.dart';
import 'package:music_world_app/repositories/playlist_repository/models/playlist.dart';

enum PlaylistStatus {initial, loading, success, failure}

class PlaylistState extends Equatable {
  const PlaylistState({
    this.playlists = const[],
    this.playlistStatus = PlaylistStatus.initial,
    this.hasMorePlaylist = true,
    this.createStatus = PlaylistStatus.initial,
    this.searchWord = '',
  });

  final List<Playlist> playlists;
  final PlaylistStatus playlistStatus;
  final bool hasMorePlaylist;
  final PlaylistStatus createStatus;
  final String searchWord;

  PlaylistState copyWith({
    PlaylistStatus Function()? playlistStatus,
    List<Playlist> Function()? playlists,
    bool Function()? hasMorePlaylist,
    PlaylistStatus Function()? createStatus,
    String Function()? searchWord,
  }) {
    return PlaylistState(
      playlistStatus: playlistStatus != null ? playlistStatus() : this.playlistStatus,
      playlists: playlists != null ? playlists() : this.playlists,
      hasMorePlaylist: hasMorePlaylist != null ? hasMorePlaylist() : this.hasMorePlaylist,
      createStatus: createStatus != null ? createStatus() : this.createStatus,
      searchWord: searchWord != null ? searchWord() : this.searchWord,
    );
  }

  @override
  List<Object?> get props => [
    playlists,
    playlistStatus,
    hasMorePlaylist,
    createStatus,
    searchWord,
  ];

}