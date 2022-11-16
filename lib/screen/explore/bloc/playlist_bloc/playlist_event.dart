import 'package:equatable/equatable.dart';

import '../../../../repositories/song_repository/models/song.dart';

abstract class PlaylistPageEvent extends Equatable {
  final List<Song> songs;
  const PlaylistPageEvent({required this.songs,});

  @override
  List<Object> get props => [
    songs,
  ];
}

class PlaylistPageSubscriptionRequest extends PlaylistPageEvent {
  const PlaylistPageSubscriptionRequest(List<Song> song) : super(songs: song);
}

class PlaylistPageLoadMoreSong extends PlaylistPageEvent {
  const PlaylistPageLoadMoreSong(List<Song> song) : super(songs: song);
}