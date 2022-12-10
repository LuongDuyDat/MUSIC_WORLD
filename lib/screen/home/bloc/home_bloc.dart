import 'package:bloc/bloc.dart';
import 'package:music_world_app/repositories/album_repository/album_repository.dart';
import 'package:music_world_app/repositories/album_repository/models/album.dart';
import 'package:music_world_app/repositories/song_repository/models/song.dart';
import 'package:music_world_app/repositories/song_repository/song_repository.dart';
import 'package:music_world_app/screen/home/bloc/home_event.dart';
import 'package:music_world_app/screen/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required AlbumRepository albumRepository,
    required SongRepository songRepository
  }) : _albumRepository = albumRepository,
      _songRepository = songRepository,
      super(const HomeState()) {
    on<HomeSubscriptionRequest>(_onSubscriptionRequest);
    on<HomeLoadMoreRecentMusic>(_onLoadMoreRecentMusic);
  }

  final AlbumRepository _albumRepository;
  final SongRepository _songRepository;

  Future<void> _onSubscriptionRequest(
    HomeSubscriptionRequest event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      newAlbumStatus: () => HomeStatus.loading,
      recentSongStatus: () => HomeStatus.loading,
    ));
      await emit.forEach<Album>(
          _albumRepository.getNewAlbums(null, null),
          onData: (album) {
            List<Album> temp = List.from(state.newAlbums);
            temp.add(album);
            return state.copyWith(newAlbums: () => temp);
          },
          onError: (_, __) {
            return state.copyWith(
              newAlbumStatus: () => HomeStatus.failure,
            );
          }
      );
      await emit.forEach<Song>(
          _songRepository.getRecentSongs(5),
          onData: (song) {
            List<Song> temp = List.from(state.recentSongs);
            temp.add(song);
            return state.copyWith(recentSongs: () => temp);
          },
          onError: (_, __) {
            return state.copyWith(
              recentSongStatus: () => HomeStatus.failure,
            );
          }
      );

    if (state.newAlbumStatus != HomeStatus.failure) {
      emit(
          state.copyWith(
              newAlbumStatus: () => HomeStatus.success
      ));
    }
    if (state.recentSongStatus != HomeStatus.failure) {
      emit(
          state.copyWith(
              recentSongStatus: () => HomeStatus.success
          ));
    }
  }

  Future<void> _onLoadMoreRecentMusic(
      HomeLoadMoreRecentMusic event,
      Emitter<HomeState> emit,
  ) async {
    if (state.hasMoreRecentSong == false) {
      return;
    }

    emit(state.copyWith(
      recentSongStatus: () => HomeStatus.loading,
    ));

    int cnt = state.recentSongs.length;

    await emit.forEach<Song>(
        _songRepository.loadMoreRecentSongs(state.recentSongs.length, 5),
        onData: (song) {
          List<Song> temp = List.from(state.recentSongs);
          temp.add(song);
          return state.copyWith(recentSongs: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            recentSongStatus: () => HomeStatus.failure,
          );
        }
    );

    if (state.recentSongStatus != HomeStatus.failure) {
      emit(
          state.copyWith(
              recentSongStatus: () => HomeStatus.success
          ));
    }

    if (state.recentSongs.length < cnt + 5) {
      emit(
          state.copyWith(
            hasMoreRecentSong: () => false,
          ));
    }
  }

}
