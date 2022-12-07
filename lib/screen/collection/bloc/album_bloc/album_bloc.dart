import 'package:bloc/bloc.dart';

import '../../../../repositories/album_repository/album_repository.dart';
import '../../../../repositories/album_repository/models/album.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  AlbumBloc({
    required AlbumRepository albumRepository
  }) : _albumRepository = albumRepository,
        super(const AlbumState()) {
    on<AlbumSubscriptionRequest>(_onSubscriptionRequest);
    on<AlbumLoadMoreAlbum>(_onLoadMoreAlbum);
    on<AlbumSearchWordChange>(_onSearchWordChange);
  }

  final AlbumRepository _albumRepository;

  Future<void> _onSubscriptionRequest(
      AlbumSubscriptionRequest event,
      Emitter<AlbumState> emit,
      ) async {
    emit(state.copyWith(
      albumStatus: () => AlbumStatus.loading,
    ));
    await emit.forEach<Album>(
        event.id == "new" ?  _albumRepository.getNewAlbums(null, 8)
            :_albumRepository.getAlbumByArtistId(event.id, 0, 10, ''),
        onData: (album) {
          List<Album> temp = List.from(state.albums);
          temp.add(album);
          return state.copyWith(albums: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            albumStatus: () => AlbumStatus.failure,
          );
        }
    );

    if (state.albumStatus != AlbumStatus.failure) {
      emit(
          state.copyWith(
              albumStatus: () => AlbumStatus.success
          ));
    }
  }

  Future<void> _onLoadMoreAlbum(
      AlbumLoadMoreAlbum event,
      Emitter<AlbumState> emit,
      ) async {

    if (state.hasMoreAlbum == false) {
      return;
    }

    emit(state.copyWith(
      albumStatus: () => AlbumStatus.loading,
    ));

    int cnt = state.albums.length;

    await emit.forEach<Album>(
        event.id == "new" ? _albumRepository.getNewAlbums(state.albums.length, state.albums.length + 5)
            : _albumRepository.getAlbumByArtistId(event.id ,state.albums.length, state.albums.length + 5, state.searchWord,),
        onData: (album) {
          List<Album> temp = List.from(state.albums);
          temp.add(album);
          return state.copyWith(albums: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            albumStatus: () => AlbumStatus.failure,
          );
        }
    );

    if (state.albums.length < cnt + 5) {
      emit(
          state.copyWith(
              hasMoreAlbum: () => false
          ));
    }

    if (state.albumStatus != AlbumStatus.failure) {
      emit(
          state.copyWith(
              albumStatus: () => AlbumStatus.success
          ));
    }
  }

  Future<void> _onSearchWordChange(
      AlbumSearchWordChange event,
      Emitter<AlbumState> emit,
      ) async {
    if (event.keyWord == state.searchWord) {
      return;
    }
    emit(state.copyWith(
      searchWord: () => event.keyWord,
    ));
    emit(state.copyWith(
      albumStatus: () => AlbumStatus.loading,
    ));
    state.albums.clear();
    await emit.forEach<Album>(
        _albumRepository.getAlbumByArtistId(event.id, 0, 10, state.searchWord,),
        onData: (album) {
          List<Album> temp = List.from(state.albums);
          temp.add(album);
          return state.copyWith(albums: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            albumStatus: () => AlbumStatus.failure,
          );
        }
    );

    if (state.albumStatus != AlbumStatus.failure) {
      emit(
          state.copyWith(
              albumStatus: () => AlbumStatus.success
          ));
    }
  }
}