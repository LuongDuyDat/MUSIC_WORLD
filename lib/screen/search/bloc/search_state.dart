import 'package:equatable/equatable.dart';
import 'package:music_world_app/repositories/artist_repository/models/artist.dart';
import 'package:music_world_app/repositories/playlist_repository/models/playlist.dart';

import '../../../repositories/album_repository/models/album.dart';
import '../../../repositories/song_repository/models/song.dart';

enum SearchStatus {initial, loading, success, failure}

class SearchState extends Equatable {
  const SearchState({
    this.albums = const[],
    this.albumStatus = SearchStatus.initial,
    this.hasMoreAlbum = true,
    this.playlists = const[],
    this.playlistStatus = SearchStatus.initial,
    this.hasMorePlaylist = true,
    this.songs = const[],
    this.songStatus = SearchStatus.initial,
    this.hasMoreSong = true,
    this.artists = const[],
    this.artistStatus = SearchStatus.initial,
    this.hasMoreArtist = true,
    this.searchWord = '',
  });

  final List<Album> albums;
  final SearchStatus albumStatus;
  final bool hasMoreAlbum;
  final List<Playlist> playlists;
  final SearchStatus playlistStatus;
  final bool hasMorePlaylist;
  final List<Song> songs;
  final SearchStatus songStatus;
  final bool hasMoreSong;
  final List<Artist> artists;
  final SearchStatus artistStatus;
  final bool hasMoreArtist;
  final String searchWord;

  SearchState copyWith({
    SearchStatus Function()? albumStatus,
    List<Album> Function()? albums,
    bool Function()? hasMoreAlbum,
    SearchStatus Function()? playlistStatus,
    List<Playlist> Function()? playlists,
    bool Function()? hasMorePlaylist,
    SearchStatus Function()? songStatus,
    List<Song> Function()? songs,
    bool Function()? hasMoreSong,
    SearchStatus Function()? artistStatus,
    List<Artist> Function()? artists,
    bool Function()? hasMoreArtist,
    String Function()? searchWord,
  }) {
    return SearchState(
      albumStatus: albumStatus != null ? albumStatus() : this.albumStatus,
      albums: albums != null ? albums() : this.albums,
      hasMoreAlbum: hasMoreAlbum != null ? hasMoreAlbum() : this.hasMoreAlbum,
      playlistStatus: playlistStatus != null ? playlistStatus() : this.playlistStatus,
      playlists: playlists != null ? playlists() : this.playlists,
      hasMorePlaylist: hasMorePlaylist != null ? hasMorePlaylist() : this.hasMorePlaylist,
      songStatus: songStatus != null ? songStatus() : this.songStatus,
      songs: songs != null ? songs() : this.songs,
      hasMoreSong: hasMoreSong != null ? hasMoreSong() : this.hasMoreSong,
      artistStatus: artistStatus != null ? artistStatus() : this.artistStatus,
      artists: artists != null ? artists() : this.artists,
      hasMoreArtist: hasMoreArtist != null ? hasMoreArtist() : this.hasMoreArtist,
      searchWord: searchWord != null ? searchWord() : this.searchWord,
    );
  }

  @override
  List<Object?> get props => [
    albums,
    albumStatus,
    hasMoreAlbum,
    playlists,
    playlistStatus,
    hasMorePlaylist,
    songs,
    songStatus,
    hasMoreSong,
    artists,
    artistStatus,
    hasMoreArtist,
    searchWord,
  ];

}