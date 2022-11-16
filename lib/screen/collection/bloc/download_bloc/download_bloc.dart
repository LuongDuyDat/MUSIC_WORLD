import 'package:bloc/bloc.dart';
import 'package:music_world_app/repositories/artist_repository/artist_repository.dart';
import 'package:music_world_app/screen/collection/bloc/download_bloc/download_event.dart';
import 'package:music_world_app/screen/collection/bloc/download_bloc/download_state.dart';

import '../../../../repositories/song_repository/models/song.dart';

class DownloadSongBloc extends Bloc<DownloadSongEvent, DownloadSongState> {
  DownloadSongBloc({
    required ArtistRepository artistRepository
  }) : _artistRepository = artistRepository,
        super(const DownloadSongState()) {
    on<DownloadSongSubscriptionRequest>(_onSubscriptionRequest);
    on<DownloadLoadMoreSong>(_onLoadMoreSong);
    on<DownloadSongSearchWordChange>(_onSearchWordChange);
  }

  final ArtistRepository _artistRepository;

  Future<void> _onSubscriptionRequest(
      DownloadSongEvent event,
      Emitter<DownloadSongState> emit,
      ) async {
    emit(state.copyWith(
      downloadSongStatus: () => DownloadSongStatus.loading,
    ));
    await emit.forEach<Song?>(
        _artistRepository.getSongsByArtist(event.id, 0, 10, ''),
        onData: (song) {
          List<Song> temp = List.from(state.downloadSongs);
          if (song != null) {
            temp.add(song);
          }
          return state.copyWith(downloadSongs: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            downloadSongStatus: () => DownloadSongStatus.failure,
          );
        }
    );

    if (state.downloadSongStatus != DownloadSongStatus.failure) {
      emit(
          state.copyWith(
              downloadSongStatus: () => DownloadSongStatus.success
          ));
    }
  }

  Future<void> _onLoadMoreSong(
      DownloadLoadMoreSong event,
      Emitter<DownloadSongState> emit,
      ) async {

    if (state.hasMoreSong == false) {
      return;
    }

    emit(state.copyWith(
      downloadSongStatus: () => DownloadSongStatus.loading,
    ));

    int cnt = state.downloadSongs.length;

    await emit.forEach<Song?>(
        _artistRepository.getSongsByArtist(event.id ,state.downloadSongs.length, state.downloadSongs.length + 5,
          state.searchWord,),
        onData: (song) {
          List<Song> temp = List.from(state.downloadSongs);
          if (song != null) {
            temp.add(song);
          }
          return state.copyWith(downloadSongs: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            downloadSongStatus: () => DownloadSongStatus.failure,
          );
        }
    );

    if (state.downloadSongs.length < cnt + 5) {
      emit(
          state.copyWith(
              hasMoreSong: () => false
          ));
    }

    if (state.downloadSongStatus != DownloadSongStatus.failure) {
      emit(
          state.copyWith(
              downloadSongStatus: () => DownloadSongStatus.success
          ));
    }
  }

  Future<void> _onSearchWordChange(
      DownloadSongSearchWordChange event,
      Emitter<DownloadSongState> emit,
      ) async {
    if (event.keyWord == state.searchWord) {
      return;
    }
    emit(state.copyWith(
      searchWord: () => event.keyWord,
    ));
    emit(state.copyWith(
      downloadSongStatus: () => DownloadSongStatus.loading,
    ));
    state.downloadSongs.clear();
    await emit.forEach<Song?>(
        _artistRepository.getSongsByArtist(event.id, 0, 10, state.searchWord,),
        onData: (song) {
          List<Song> temp = List.from(state.downloadSongs);
          if (song != null) {
            temp.add(song);
          }
          return state.copyWith(downloadSongs: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            downloadSongStatus: () => DownloadSongStatus.failure,
          );
        }
    );

    if (state.downloadSongStatus != DownloadSongStatus.failure) {
      emit(
          state.copyWith(
              downloadSongStatus: () => DownloadSongStatus.success
          ));
    }
  }
}