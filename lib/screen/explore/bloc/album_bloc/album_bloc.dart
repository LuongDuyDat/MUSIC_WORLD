import 'dart:math';

import 'package:bloc/bloc.dart';

import '../../../../repositories/song_repository/models/song.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumPageBloc extends Bloc<AlbumPageEvent, AlbumPageState> {
  AlbumPageBloc() : super(const AlbumPageState()) {
    on<AlbumPageSubscriptionRequest>(_onSubscriptionRequest);
    on<AlbumPageLoadMoreSong>(_onLoadMoreSong);
  }


  Future<void> _onSubscriptionRequest(
      AlbumPageSubscriptionRequest event,
      Emitter<AlbumPageState> emit,
      ) async {
    emit(state.copyWith(
      songStatus: () => AlbumPageStatus.loading,
    ));

    List<Song> temp = event.songs.sublist(0, min(5, event.songs.length),);
    emit(state.copyWith(
      songs: () => temp,
      songStatus: () => AlbumPageStatus.success,
    ));
  }

  Future<void> _onLoadMoreSong(
      AlbumPageLoadMoreSong event,
      Emitter<AlbumPageState> emit,
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
      songStatus: () => AlbumPageStatus.loading,
    ));

    List<Song> temp = event.songs.sublist(0, min(state.songs.length + 5, event.songs.length),);
    emit(state.copyWith(
      songs: () => temp,
      songStatus: () => AlbumPageStatus.success,
    ));
  }

}