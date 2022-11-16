import 'package:equatable/equatable.dart';

import '../../../repositories/song_repository/models/song.dart';

enum SongStatus {initial, loading, success, failure}

class SongState extends Equatable {
  const SongState({
    this.songSuggestion = const[],
    this.songSuggestionStatus = SongStatus.initial,
  });

  final List<Song> songSuggestion;
  final SongStatus songSuggestionStatus;

  SongState copyWith({
    SongStatus Function()? songSuggestionStatus,
    List<Song> Function()? songSuggestion,
  }) {
    return SongState(
      songSuggestionStatus: songSuggestionStatus != null ? songSuggestionStatus() : this.songSuggestionStatus,
      songSuggestion: songSuggestion != null ? songSuggestion() : this.songSuggestion,
    );
  }

  @override
  List<Object?> get props => [
    songSuggestion,
    songSuggestionStatus,
  ];

}