import 'package:equatable/equatable.dart';
import 'package:music_world_app/repositories/artist_repository/models/artist.dart';

import '../../../../repositories/song_repository/models/song.dart';

abstract class PlaylistEvent extends Equatable {
  const PlaylistEvent({
    required this.id,
  });

  final dynamic id;

  @override
  List<Object> get props => [
    id,
  ];
}

class PlaylistSubscriptionRequest extends PlaylistEvent {
  const PlaylistSubscriptionRequest(dynamic id) : super(id: id);
}

class PlaylistLoadMorePlaylist extends PlaylistEvent {
  const PlaylistLoadMorePlaylist(dynamic id) : super(id: id);
}

class CreatePlaylist extends PlaylistEvent {
  const CreatePlaylist(dynamic id, {
    required this.songs,
    required this.name,
    required this.artists,
    required this.picture,
    required this.introduction,
  }) : super(id: id);

  final List<Song> songs;
  final String name;
  final List<Artist> artists;
  final String picture;
  final String introduction;

  @override
  List<Object> get props => [
    id,
    songs,
    name,
    artists,
    picture,
    introduction,
  ];
}

class PlaylistSearchWordChange extends PlaylistEvent {
  const PlaylistSearchWordChange({required id, required this.keyWord,}) : super(id: id);

  final String keyWord;

  @override
  List<Object> get props => [
    id,
    keyWord,
  ];
}