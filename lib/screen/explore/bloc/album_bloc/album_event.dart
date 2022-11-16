import 'package:equatable/equatable.dart';

import '../../../../repositories/song_repository/models/song.dart';

abstract class AlbumPageEvent extends Equatable {
  final List<Song> songs;
  const AlbumPageEvent({required this.songs,});

  @override
  List<Object> get props => [
    songs,
  ];
}

class AlbumPageSubscriptionRequest extends AlbumPageEvent {
  const AlbumPageSubscriptionRequest(List<Song> song) : super(songs: song);
}

class AlbumPageLoadMoreSong extends AlbumPageEvent {
  const AlbumPageLoadMoreSong(List<Song> song) : super(songs: song);
}