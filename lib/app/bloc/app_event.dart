import 'package:equatable/equatable.dart';

import '../../repositories/album_repository/models/album.dart';
import '../../repositories/playlist_repository/models/playlist.dart';
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

class HomeAddSong extends HomeScreenEvent {
  const HomeAddSong({required this.song});

  final Song song;

  @override
  List<Object> get props => [song];
}

class HomePlayPlaylist extends HomeScreenEvent {
  const HomePlayPlaylist({required this.playlist, this.index,});

  final Playlist playlist;
  final int? index;

  @override
  List<Object> get props => [playlist];
}

class HomePlayAlbum extends HomeScreenEvent {
  const HomePlayAlbum({required this.album, this.index,});

  final Album album;
  final int? index;

  @override
  List<Object> get props => [album];
}

class HomeNextTopicClick extends HomeScreenEvent {
  const HomeNextTopicClick();
}

class HomePrevTopicClick extends HomeScreenEvent {
  const HomePrevTopicClick();
}