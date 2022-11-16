import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:music_world_app/screen/explore/bloc/playlist_bloc/playlist_event.dart';
import 'package:music_world_app/screen/explore/bloc/playlist_bloc/playlist_state.dart';

import '../../../../repositories/song_repository/models/song.dart';

class PlaylistPageBloc extends Bloc<PlaylistPageEvent, PlaylistPageState> {
  PlaylistPageBloc() : super(const PlaylistPageState()) {
    on<PlaylistPageSubscriptionRequest>(_onSubscriptionRequest);
    on<PlaylistPageLoadMoreSong>(_onLoadMoreSong);
  }


  Future<void> _onSubscriptionRequest(
      PlaylistPageSubscriptionRequest event,
      Emitter<PlaylistPageState> emit,
      ) async {
    emit(state.copyWith(
      songStatus: () => PlaylistPageStatus.loading,
    ));

    List<Song> temp = event.songs.sublist(0, min(5, event.songs.length),);
    emit(state.copyWith(
      songs: () => temp,
      songStatus: () => PlaylistPageStatus.success,
    ));
  }

  Future<void> _onLoadMoreSong(
      PlaylistPageLoadMoreSong event,
      Emitter<PlaylistPageState> emit,
      ) async {
    if (state.hasMoreSong == false) {
      return;
    }

    if (event.songs.length == state.songs.length) {
      emit(state.copyWith(
        hasMoreSong: () => false,
      ));
      return;
    }

    emit(state.copyWith(
      songStatus: () => PlaylistPageStatus.loading,
    ));

    List<Song> temp = event.songs.sublist(0, min(state.songs.length + 5, event.songs.length),);
    emit(state.copyWith(
      songs: () => temp,
      songStatus: () => PlaylistPageStatus.success,
    ));

  }

}