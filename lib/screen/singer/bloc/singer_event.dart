import 'package:equatable/equatable.dart';

import '../../../repositories/album_repository/models/album.dart';
import '../../../repositories/song_repository/models/song.dart';

abstract class SingerEvent extends Equatable {
  const SingerEvent();

  @override
  List<Object> get props => [];
}

class SingerLoadMoreSong extends SingerEvent {
  final List<Song> songs;
  const SingerLoadMoreSong({required this.songs});

  @override
  List<Object> get props => [
    songs,
  ];
}

class SingerLoadMoreAlbum extends SingerEvent {
  final List<Album> albums;
  const SingerLoadMoreAlbum({required this.albums});

  @override
  List<Object> get props => [
    albums,
  ];
}

class SingerClickFollowButton extends SingerEvent {
  const SingerClickFollowButton();

  @override
  List<Object> get props => [];
}