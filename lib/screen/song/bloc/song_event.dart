import 'package:equatable/equatable.dart';

import '../../../repositories/song_repository/models/song.dart';

abstract class SongEvent extends Equatable {
  final Song song;
  const SongEvent({required this.song,});

  @override
  List<Object> get props => [
    song,
  ];
}

class SuggestionSongSubscriptionRequest extends SongEvent {
  const SuggestionSongSubscriptionRequest(Song song) : super(song: song);
}

class CheckFavorites extends SongEvent {
  const CheckFavorites({required Song song}) : super(song: song);
}

class AddFavoriteSong extends SongEvent {
  const AddFavoriteSong({required Song song}) : super(song: song);
}

class RemoveFavoriteSong extends SongEvent {
  const RemoveFavoriteSong({required Song song}) : super(song: song);
}
