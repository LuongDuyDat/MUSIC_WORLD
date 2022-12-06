import 'dart:async';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';

import '../../repositories/song_repository/models/song.dart';
import '../../util/audio.dart';
import '../../util/globals.dart';
import 'app_event.dart';
import 'app_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  StreamSubscription<Playing?>? _playingSubscription;

  HomeScreenBloc({
    required AssetsAudioPlayer assetsAudioPlayer,
  }) : _assetsAudioPlayer = assetsAudioPlayer,
        super(const HomeScreenState()) {
    on<HomeChangeIsPlaying>(_onChangeIsPlaying);
    on<HomeNextSongClick>(_onNextSongClick);
    on<HomePrevSongClick>(_onPrevSongClick);
    on<HomeOnClickSong>(_onClickSong);
    on<HomePlayPlaylist>(_onPlayPlaylist);
    on<HomeAddSong>(_onAddSong);
    on<HomeNextTopicClick>(_onNextTopicClick);
    on<HomePrevTopicClick>(_onPrevTopicClick);
  }

  @override
  Future<void> close() {
    _playingSubscription?.cancel();
    return super.close();
  }

  final AssetsAudioPlayer _assetsAudioPlayer;

  void _onChangeIsPlaying(
      HomeChangeIsPlaying event,
      Emitter<HomeScreenState> emit,
      ) {
    if (event.isPlaying == false) {
      _assetsAudioPlayer.stop();
    }
    emit(state.copyWith(
      isPlaying: () => event.isPlaying,
    ));
  }

  void _onNextSongClick(
      HomeNextSongClick event,
      Emitter<HomeScreenState> emit,
      ) {
    Box songBox = Hive.box<Song>('song');
    var items = songBox.values.toList();
    int resultI = -1;
    for (int i = 0; i < items.length; i++) {
      if (state.playingSong.elementAt(state.playingSong.length - 1).key == items[i].key) {
        resultI = i;
        break;
      }
    }
    Random rand = Random();
    if (shuffleSingle == 0) {
      resultI = (resultI + 1) % items.length;
    } else {
      int index = resultI;
      while (index == resultI && items.length != 1) {
        index = rand.nextInt(items.length);
      }
      resultI = index;
    }
    List<Song> tempSong = List.from(state.playingSong);
    tempSong.add(items[resultI]);
    play(items[resultI]);
    emit(state.copyWith(
      playingSong: () => tempSong,
      isPlaying: () => true,
    ));
  }

  void _onAddSong(
      HomeAddSong event,
      Emitter<HomeScreenState> emit,
      ) {
    List<Song> tempSong = List.from(state.playingSong);
    tempSong.add(event.song);
    emit(state.copyWith(
      playingSong: () => tempSong,
      isPlaying: () => true,
    ));
  }

  void _onPrevSongClick(
      HomePrevSongClick event,
      Emitter<HomeScreenState> emit,
      ) {
    if (state.playingSong.length > 1) {
      var resultI = state.playingSong.elementAt(state.playingSong.length - 2);
      List<Song> temp = List.from(state.playingSong);
      temp.removeAt(temp.length - 1);
      play(resultI);
      emit(state.copyWith(
        playingSong: () => temp,
        isPlaying: () => true,
      ));
    } else {
      Box songBox = Hive.box<Song>('song');
      var items = songBox.values.toList();
      Random rand = Random();
      int resultI = rand.nextInt(items.length);
      List<Song> temp = [items[resultI]];
      play(items[resultI]);
      emit(state.copyWith(
        playingSong: () => temp,
        isPlaying: () => true,
      ));
    }

  }

  void _onClickSong(
      HomeOnClickSong event,
      Emitter<HomeScreenState> emit,
      ) {
    _playingSubscription?.cancel();
    play(event.song);
    emit(state.copyWith(
      playingSong: () => [event.song],
      isPlaying: () => true,
    ));
  }

  Future<void> _onPlayPlaylist (
      HomePlayPlaylist event,
      Emitter<HomeScreenState> emit,
      ) async {
    await _playingSubscription?.cancel();
    emit(state.copyWith(
      playingSong: () => [],
      isPlaying: () => false,
    ));
    _playingSubscription = _assetsAudioPlayer.current.listen((event) => add(HomeAddSong(song: event?.audio.audio.metas.extra?["song"])));
    await playPlaylist(event.playlist);
    emit(state.copyWith(
      playingPlaylist: () => event.playlist,
      isPlaying: () => true,
    ));
  }

  void _onNextTopicClick (
      HomeNextTopicClick event,
      Emitter<HomeScreenState> emit,
      ) {
    _assetsAudioPlayer.next();
  }

  void _onPrevTopicClick (
      HomePrevTopicClick event,
      Emitter<HomeScreenState> emit,
      ) {
    _assetsAudioPlayer.previous();
  }

}