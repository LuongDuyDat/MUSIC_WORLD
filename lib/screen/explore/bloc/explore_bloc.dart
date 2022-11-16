import 'package:bloc/bloc.dart';
import 'package:music_world_app/screen/explore/bloc/explore_event.dart';
import 'package:music_world_app/screen/explore/bloc/explore_state.dart';

import '../../../repositories/song_repository/models/song.dart';
import '../../../repositories/song_repository/song_repository.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc({
    required SongRepository songRepository
  }) : _songRepository = songRepository,
        super(const ExploreState()) {
    on<ExploreSubscriptionRequest>(_onSubscriptionRequest);
    on<ExploreLoadMoreMusicChart>(_onLoadMoreMusicChart);
  }

  final SongRepository _songRepository;

  Future<void> _onSubscriptionRequest(
      ExploreSubscriptionRequest event,
      Emitter<ExploreState> emit,
      ) async {
    emit(state.copyWith(
      songChartStatus: () => ExploreStatus.loading,
    ));
    await emit.forEach<Song>(
        _songRepository.getPopularSongs(0, 5),
        onData: (song) {
          List<Song> temp = List.from(state.songChart);
          temp.add(song);
          return state.copyWith(songChart: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            songChartStatus: () => ExploreStatus.failure,
          );
        }
    );

    if (state.songChartStatus != ExploreStatus.failure) {
      emit(
          state.copyWith(
              songChartStatus: () => ExploreStatus.success
          ));
    }
  }

  Future<void> _onLoadMoreMusicChart(
      ExploreLoadMoreMusicChart event,
      Emitter<ExploreState> emit,
      ) async {

    if (state.hasMoreSongChart == false) {
      return;
    }

    emit(state.copyWith(
      songChartStatus: () => ExploreStatus.loading,
    ));

    int cnt = state.songChart.length;

    await emit.forEach<Song>(
        _songRepository.getPopularSongs(state.songChart.length, state.songChart.length + 5),
        onData: (song) {
          List<Song> temp = List.from(state.songChart);
          temp.add(song);
          return state.copyWith(songChart: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            songChartStatus: () => ExploreStatus.failure,
          );
        }
    );

    if (state.songChart.length < cnt + 5) {
      emit(
        state.copyWith(
          hasMoreSongChart: () => false
        ));
    }

    if (state.songChartStatus != ExploreStatus.failure) {
      emit(
          state.copyWith(
              songChartStatus: () => ExploreStatus.success
          ));
    }
  }

}
