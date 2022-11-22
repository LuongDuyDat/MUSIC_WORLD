import 'package:bloc/bloc.dart';
import 'package:music_world_app/screen/song/bloc/song_event.dart';
import 'package:music_world_app/screen/song/bloc/song_state.dart';
import 'package:music_world_app/util/globals.dart';

import '../../../repositories/song_repository/models/song.dart';
import '../../../repositories/song_repository/song_repository.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  SongBloc({
    required SongRepository songRepository
  }) : _songRepository = songRepository,
        super(const SongState()) {
    on<SuggestionSongSubscriptionRequest>(_onSuggestionSubscriptionRequest);
    on<CheckFavorites>(_onCheckFavorites);
    on<AddFavoriteSong>(_onAddFavoriteSong);
    on<RemoveFavoriteSong>(_onRemoveFavoriteSong);
  }

  final SongRepository _songRepository;

  Future<void> _onSuggestionSubscriptionRequest(
      SuggestionSongSubscriptionRequest event,
      Emitter<SongState> emit,
      ) async {
    emit(state.copyWith(
      songSuggestionStatus: () => SongStatus.loading,
    ));
    await emit.forEach<Song>(
        _songRepository.getSuggestionSong(event.song, 3),
        onData: (song) {
          List<Song> temp = List.from(state.songSuggestion);
          temp.add(song);
          return state.copyWith(songSuggestion: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            songSuggestionStatus: () => SongStatus.failure,
          );
        }
    );

    if (state.songSuggestionStatus != SongStatus.failure) {
      emit(
          state.copyWith(
              songSuggestionStatus: () => SongStatus.success
          ));
    }
  }

  void _onCheckFavorites(
      CheckFavorites event,
      Emitter<SongState> emit,
      ) {
    emit(state.copyWith(
      isFavorites: () => _songRepository.checkFavorite(account, event.song),
    ));
  }

  Future<void> _onAddFavoriteSong(
      AddFavoriteSong event,
      Emitter<SongState> emit,
      ) async {
    emit(state.copyWith(
      addFavoriteStatus: () => SongStatus.loading,
    ));
    _songRepository.addFavorite(account, event.song);
    emit(state.copyWith(
      addFavoriteStatus: () => SongStatus.success,
      isFavorites: () => true,
    ));
  }

  Future<void> _onRemoveFavoriteSong(
      RemoveFavoriteSong event,
      Emitter<SongState> emit,
      ) async {
    emit(state.copyWith(
      addFavoriteStatus: () => SongStatus.loading,
    ));
    _songRepository.removeFavorite(account, event.song);
    emit(state.copyWith(
      addFavoriteStatus: () => SongStatus.success,
      isFavorites: () => false,
    ));
  }

}