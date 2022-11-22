import 'package:equatable/equatable.dart';

import '../../../repositories/song_repository/models/song.dart';

enum SongStatus {initial, loading, success, failure}

class SongState extends Equatable {
  const SongState({
    this.songSuggestion = const[],
    this.songSuggestionStatus = SongStatus.initial,
    this.isFavorites = false,
    this.addFavoriteStatus = SongStatus.success,
  });

  final List<Song> songSuggestion;
  final SongStatus songSuggestionStatus;
  final bool isFavorites;
  final SongStatus addFavoriteStatus;

  SongState copyWith({
    SongStatus Function()? songSuggestionStatus,
    List<Song> Function()? songSuggestion,
    bool Function()? isFavorites,
    SongStatus Function()? addFavoriteStatus,
  }) {
    return SongState(
      songSuggestionStatus: songSuggestionStatus != null ? songSuggestionStatus() : this.songSuggestionStatus,
      songSuggestion: songSuggestion != null ? songSuggestion() : this.songSuggestion,
      isFavorites: isFavorites != null ? isFavorites() : this.isFavorites,
      addFavoriteStatus: addFavoriteStatus!= null ? addFavoriteStatus() : this.addFavoriteStatus,
    );
  }

  @override
  List<Object?> get props => [
    songSuggestion,
    songSuggestionStatus,
    isFavorites,
    addFavoriteStatus,
  ];

}