import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:music_world_app/repositories/album_repository/models/album.dart';
import 'package:music_world_app/repositories/artist_repository/artist_repository.dart';
import 'package:music_world_app/screen/singer/bloc/singer_event.dart';
import 'package:music_world_app/screen/singer/bloc/singer_state.dart';

import '../../../repositories/song_repository/models/song.dart';

class SingerBloc extends Bloc<SingerEvent, SingerState> {
  SingerBloc({
    required ArtistRepository artistRepository,
    required followingId,
    required followerId,
  }) : _artistRepository = artistRepository,
       _followerId = followerId,
       _followingId = followingId,
        super(SingerState(isFollowing: artistRepository.isFollowingArtist(followingId, followerId))) {
    on<SingerLoadMoreSong>(_onLoadMoreSong);
    on<SingerLoadMoreAlbum>(_onLoadMoreAlbum);
    on<SingerClickFollowButton>(_onClickFollowButton);
  }

  final ArtistRepository _artistRepository;
  final dynamic _followingId;
  final dynamic _followerId;


  Future<void> _onLoadMoreSong(
      SingerLoadMoreSong event,
      Emitter<SingerState> emit,
      ) async {
    if (state.hasMoreSong == false) {
      return;
    }

    if (state.songs.length == event.songs.length) {
      emit(state.copyWith(
        hasMoreSong: () => false,
      ));
    }

    List<Song> temp = List.from(state.songs);

    for (int i = state.songs.length; i < min(state.songs.length + 5, event.songs.length); i++) {
      temp.add(event.songs.elementAt(i));
    }

    emit(state.copyWith(
      songs: () => temp,
    ));
  }

  Future<void> _onLoadMoreAlbum(
      SingerLoadMoreAlbum event,
      Emitter<SingerState> emit,
      ) async {
    if (state.hasMoreAlbum == false) {
      return;
    }

    if (state.albums.length == event.albums.length) {
      emit(state.copyWith(
        hasMoreAlbum: () => false,
      ));
    }

    List<Album> temp = List.from(state.albums);

    for (int i = state.albums.length; i < min(state.albums.length + 5, event.albums.length); i++) {
      temp.add(event.albums.elementAt(i));
    }

    emit(state.copyWith(
      albums: () => temp,
    ));
  }

  Future<void> _onClickFollowButton(
      SingerClickFollowButton event,
      Emitter<SingerState> emit,
      ) async {
    emit(state.copyWith(
      followingStatus: () => SingerStatus.loading,
    ));

    bool success = _artistRepository.followingArtist(_followingId, _followerId, state.isFollowing);

    if (success) {
      emit(
          state.copyWith(
            followingStatus: () => SingerStatus.success,
            isFollowing: () => !state.isFollowing,
          ));
    } else {
      emit(
          state.copyWith(
            followingStatus: () => SingerStatus.failure,
          ));
    }

  }

}