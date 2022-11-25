import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc({
    required AssetsAudioPlayer assetsAudioPlayer,
  }) : _assetsAudioPlayer = assetsAudioPlayer,
        super(const HomeScreenState()) {
    on<HomeChangeIsPlaying>(_onChangeIsPlaying);
  }

  final AssetsAudioPlayer _assetsAudioPlayer;

  void _onChangeIsPlaying(
      HomeChangeIsPlaying event,
      Emitter<HomeScreenState> emit,
      ) {
    emit(state.copyWith(
      isPlaying: () => event.isPlaying,
    ));
  }

}