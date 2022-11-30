import 'package:equatable/equatable.dart';

import '../../repositories/song_repository/models/song.dart';

abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object> get props => [];
}

class HomeChangeIsPlaying extends HomeScreenEvent {
  const HomeChangeIsPlaying({required this.isPlaying,});

  final bool isPlaying;

  @override
  List<Object> get props => [isPlaying];
}

class HomeNextSongClick extends HomeScreenEvent {
  const HomeNextSongClick();
}

class HomePrevSongClick extends HomeScreenEvent {
  const HomePrevSongClick();
}

class HomeOnClickSong extends HomeScreenEvent {
  const HomeOnClickSong({required this.song});

  final Song song;

  @override
  List<Object> get props => [song];
}