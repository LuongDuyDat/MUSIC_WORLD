import 'package:bloc/bloc.dart';
import 'package:music_world_app/repositories/artist_repository/models/artist.dart';
import 'package:music_world_app/repositories/playlist_repository/models/playlist.dart';
import 'package:music_world_app/repositories/playlist_repository/playlist_repository.dart';
import 'package:music_world_app/repositories/song_repository/song_repository.dart';
import 'package:music_world_app/screen/search/bloc/search_event.dart';
import 'package:music_world_app/screen/search/bloc/search_state.dart';

import '../../../repositories/album_repository/album_repository.dart';
import '../../../repositories/album_repository/models/album.dart';
import '../../../repositories/artist_repository/artist_repository.dart';
import '../../../repositories/song_repository/models/song.dart';
import '../../../util/globals.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required AlbumRepository albumRepository,
    required PlaylistRepository playlistRepository,
    required SongRepository songRepository,
    required ArtistRepository artistRepository,
  }) : _albumRepository = albumRepository,
       _playlistRepository = playlistRepository,
       _songRepository = songRepository,
       _artistRepository = artistRepository,
        super(const SearchState()) {
    on<SearchSubscriptionRequest>(_onSubscriptionRequest);
    on<SearchLoadMoreAlbumEvent>(_onLoadMoreAlbum);
    on<SearchLoadMorePlaylistEvent>(_onLoadMorePlaylist);
    on<SearchLoadMoreSongEvent>(_onLoadMoreSong);
    on<SearchLoadMoreArtistEvent>(_onLoadMoreArtist);
    on<SearchWordChange>(_onSearchWordChange);
    on<SearchAddRecentSearch>(_onAddRecentSearch);
  }

  final AlbumRepository _albumRepository;
  final PlaylistRepository _playlistRepository;
  final SongRepository _songRepository;
  final ArtistRepository _artistRepository;

  void _onAddRecentSearch (
      SearchAddRecentSearch event,
      Emitter<SearchState> emit,
      ) {
    _artistRepository.addRecentSearch(account.key, event.content);
  }

  void _onSubscriptionRequest (
      SearchSubscriptionRequest event,
      Emitter<SearchState> emit,
      ) {
    emit(state.copyWith(
      recentSearchStatus: () => SearchStatus.loading,
    ));
    List<String> temp = _artistRepository.getRecentSearch(account.key);
    print(temp.length);
    emit(state.copyWith(
      recentSearchStatus: () => SearchStatus.success,
      recentSearch: () => temp,
    ));
  }

  Future<void> _onLoadMoreAlbum (
      SearchLoadMoreAlbumEvent event,
      Emitter<SearchState> emit,
      ) async {

    if (state.hasMoreAlbum == false) {
      return;
    }

    emit(state.copyWith(
      albumStatus: () => SearchStatus.loading,
    ));

    int cnt = state.albums.length;

    await emit.forEach<Album>(
        _albumRepository.getAlbumByKeyword(state.albums.length, state.albums.length + 10, state.searchWord),
        onData: (album) {
          List<Album> temp = List.from(state.albums);
          temp.add(album);
          return state.copyWith(albums: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            albumStatus: () => SearchStatus.failure,
          );
        }
    );

    if (state.albums.length < cnt + 10) {
      emit(
          state.copyWith(
              hasMoreAlbum: () => false
          ));
    }

    if (state.albumStatus != SearchStatus.failure) {
      emit(
          state.copyWith(
              albumStatus: () => SearchStatus.success
          ));
    }
  }

  Future<void> _onLoadMorePlaylist (
      SearchLoadMorePlaylistEvent event,
      Emitter<SearchState> emit,
      ) async {

    if (state.hasMorePlaylist == false) {
      return;
    }

    emit(state.copyWith(
      playlistStatus: () => SearchStatus.loading,
    ));

    int cnt = state.playlists.length;

    await emit.forEach<Playlist>(
        _playlistRepository.getPlaylistsByKeyword(state.playlists.length, state.playlists.length + 10, state.searchWord),
        onData: (playlist) {
          List<Playlist> temp = List.from(state.playlists);
          temp.add(playlist);
          return state.copyWith(playlists: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            playlistStatus: () => SearchStatus.failure,
          );
        }
    );

    if (state.playlists.length < cnt + 10) {
      emit(
          state.copyWith(
              hasMorePlaylist: () => false
          ));
    }

    if (state.playlistStatus != SearchStatus.failure) {
      emit(
          state.copyWith(
              playlistStatus: () => SearchStatus.success
          ));
    }
  }

  Future<void> _onLoadMoreSong (
      SearchLoadMoreSongEvent event,
      Emitter<SearchState> emit,
      ) async {

    if (state.hasMoreSong == false) {
      return;
    }

    emit(state.copyWith(
      songStatus: () => SearchStatus.loading,
    ));

    int cnt = state.songs.length;

    await emit.forEach<Song>(
        _songRepository.getSongByKeyword(state.songs.length, state.songs.length + 10, state.searchWord),
        onData: (song) {
          List<Song> temp = List.from(state.songs);
          temp.add(song);
          return state.copyWith(songs: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            songStatus: () => SearchStatus.failure,
          );
        }
    );

    if (state.songs.length < cnt + 10) {
      emit(
          state.copyWith(
              hasMoreSong: () => false
          ));
    }

    if (state.songStatus != SearchStatus.failure) {
      emit(
          state.copyWith(
              songStatus: () => SearchStatus.success
          ));
    }
  }

  Future<void> _onLoadMoreArtist (
      SearchLoadMoreArtistEvent event,
      Emitter<SearchState> emit,
      ) async {

    if (state.hasMoreArtist == false) {
      return;
    }

    emit(state.copyWith(
      artistStatus: () => SearchStatus.loading,
    ));

    int cnt = state.artists.length;

    await emit.forEach<Artist>(
        _artistRepository.getArtistByKeyword(state.artists.length, state.artists.length + 10, state.searchWord),
        onData: (artist) {
          List<Artist> temp = List.from(state.artists);
          temp.add(artist);
          return state.copyWith(artists: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            artistStatus: () => SearchStatus.failure,
          );
        }
    );

    if (state.artists.length < cnt + 10) {
      emit(
          state.copyWith(
              hasMoreArtist: () => false
          ));
    }

    if (state.artistStatus != SearchStatus.failure) {
      emit(
          state.copyWith(
              artistStatus: () => SearchStatus.success
          ));
    }
  }

  Future<void> _onSearchWordChange(
      SearchWordChange event,
      Emitter<SearchState> emit,
      ) async {
    if (event.keyWord == state.searchWord) {
      return;
    }
    emit(state.copyWith(
      hasMoreAlbum: () => true,
      hasMorePlaylist: () => true,
      hasMoreSong: () => true,
      hasMoreArtist: () => true,
      searchWord: () => event.keyWord,
    ));
    emit(state.copyWith(
      albumStatus: () => SearchStatus.loading,
      albums: () => [],
    ));
    await emit.forEach<Album>(
        _albumRepository.getAlbumByKeyword(0, 8, state.searchWord,),
        onData: (album) {
          List<Album> temp = List.from(state.albums);
          temp.add(album);
          return state.copyWith(albums: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            albumStatus: () => SearchStatus.failure,
          );
        }
    );

    if (state.albumStatus != SearchStatus.failure) {
      emit(
          state.copyWith(
              albumStatus: () => SearchStatus.success
          ));
    }

    emit(state.copyWith(
      playlistStatus: () => SearchStatus.loading,
      playlists: () => [],
    ));
    await emit.forEach<Playlist>(
        _playlistRepository.getPlaylistsByKeyword(0, 8, state.searchWord,),
        onData: (playlist) {
          List<Playlist> temp = List.from(state.playlists);
          temp.add(playlist);
          return state.copyWith(playlists: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            playlistStatus: () => SearchStatus.failure,
          );
        }
    );

    if (state.playlistStatus != SearchStatus.failure) {
      emit(
          state.copyWith(
              playlistStatus: () => SearchStatus.success
          ));
    }

    emit(state.copyWith(
      songStatus: () => SearchStatus.loading,
      songs: () => [],
    ));
    await emit.forEach<Song>(
        _songRepository.getSongByKeyword(0, 8, state.searchWord,),
        onData: (song) {
          List<Song> temp = List.from(state.songs);
          temp.add(song);
          return state.copyWith(songs: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            songStatus: () => SearchStatus.failure,
          );
        }
    );

    if (state.songStatus != SearchStatus.failure) {
      emit(
          state.copyWith(
              songStatus: () => SearchStatus.success
          ));
    }

    emit(state.copyWith(
      artistStatus: () => SearchStatus.loading,
      artists:  () => [],
    ));
    await emit.forEach<Artist>(
        _artistRepository.getArtistByKeyword(0, 8, state.searchWord,),
        onData: (artist) {
          List<Artist> temp = List.from(state.artists);
          temp.add(artist);
          return state.copyWith(artists: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            artistStatus: () => SearchStatus.failure,
          );
        }
    );

    if (state.artistStatus != SearchStatus.failure) {
      emit(
          state.copyWith(
              artistStatus: () => SearchStatus.success
          ));
    }
  }
}