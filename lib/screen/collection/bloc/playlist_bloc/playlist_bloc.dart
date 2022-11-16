import 'package:bloc/bloc.dart';
import 'package:music_world_app/repositories/playlist_repository/models/playlist.dart';
import 'package:music_world_app/screen/collection/bloc/playlist_bloc/playlist_event.dart';
import 'package:music_world_app/screen/collection/bloc/playlist_bloc/playlist_state.dart';

import '../../../../repositories/playlist_repository/playlist_repository.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc({
    required PlaylistRepository playlistRepository
  }) : _playlistRepository = playlistRepository,
        super(const PlaylistState()) {
    on<PlaylistSubscriptionRequest>(_onSubscriptionRequest);
    on<PlaylistLoadMorePlaylist>(_onLoadMorePlaylist);
    on<CreatePlaylist>(_onCreatePlaylist);
    on<PlaylistSearchWordChange>(_onSearchWordChange);
  }

  final PlaylistRepository _playlistRepository;

  Future<void> _onSubscriptionRequest(
      PlaylistSubscriptionRequest event,
      Emitter<PlaylistState> emit,
      ) async {
    emit(state.copyWith(
      playlistStatus: () => PlaylistStatus.loading,
    ));
    await emit.forEach<Playlist>(
        _playlistRepository.getPlaylistsByArtistId(event.id, 0, 10, ''),
        onData: (playlist) {
          List<Playlist> temp = List.from(state.playlists);
          temp.add(playlist);
          return state.copyWith(playlists: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            playlistStatus: () => PlaylistStatus.failure,
          );
        }
    );

    if (state.playlistStatus != PlaylistStatus.failure) {
      emit(
          state.copyWith(
              playlistStatus: () => PlaylistStatus.success
          ));
    }
  }

  Future<void> _onLoadMorePlaylist(
      PlaylistLoadMorePlaylist event,
      Emitter<PlaylistState> emit,
      ) async {

    if (state.hasMorePlaylist == false) {
      return;
    }

    emit(state.copyWith(
      playlistStatus: () => PlaylistStatus.loading,
    ));

    int cnt = state.playlists.length;

    await emit.forEach<Playlist>(
        _playlistRepository.getPlaylistsByArtistId(event.id ,state.playlists.length, state.playlists.length + 5, state.searchWord,),
        onData: (playlist) {
          List<Playlist> temp = List.from(state.playlists);
          temp.add(playlist);
          return state.copyWith(playlists: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            playlistStatus: () => PlaylistStatus.failure,
          );
        }
    );

    if (state.playlists.length < cnt + 5) {
      emit(
          state.copyWith(
              hasMorePlaylist: () => false
          ));
    }

    if (state.playlistStatus != PlaylistStatus.failure) {
      emit(
          state.copyWith(
              playlistStatus: () => PlaylistStatus.success
          ));
    }
  }

  Future<void> _onCreatePlaylist(
      CreatePlaylist event,
      Emitter<PlaylistState> emit,
      ) async {
    emit(state.copyWith(
      createStatus: () => PlaylistStatus.loading,
    ));
  }

  Future<void> _onSearchWordChange(
      PlaylistSearchWordChange event,
      Emitter<PlaylistState> emit,
      ) async {
    if (event.keyWord == state.searchWord) {
      return;
    }
    emit(state.copyWith(
      searchWord: () => event.keyWord,
    ));
    emit(state.copyWith(
      playlistStatus: () => PlaylistStatus.loading,
    ));
    state.playlists.clear();
    await emit.forEach<Playlist>(
        _playlistRepository.getPlaylistsByArtistId(event.id, 0, 10, state.searchWord,),
        onData: (playlist) {
          List<Playlist> temp = List.from(state.playlists);
          temp.add(playlist);
          return state.copyWith(playlists: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            playlistStatus: () => PlaylistStatus.failure,
          );
        }
    );

    if (state.playlistStatus != PlaylistStatus.failure) {
      emit(
          state.copyWith(
              playlistStatus: () => PlaylistStatus.success
          ));
    }
  }
}