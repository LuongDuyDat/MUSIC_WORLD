import 'package:equatable/equatable.dart';
import 'package:music_world_app/repositories/song_repository/models/song.dart';

enum DownloadSongStatus {initial, loading, success, failure}

class DownloadSongState extends Equatable {
  const DownloadSongState({
    this.downloadSongs = const[],
    this.downloadSongStatus = DownloadSongStatus.initial,
    this.hasMoreSong = true,
    this.searchWord = '',
  });

  final List<Song> downloadSongs;
  final DownloadSongStatus downloadSongStatus;
  final bool hasMoreSong;
  final String searchWord;

  DownloadSongState copyWith({
    DownloadSongStatus Function()? downloadSongStatus,
    List<Song> Function()? downloadSongs,
    bool Function()? hasMoreSong,
    String Function()? searchWord,
  }) {
    return DownloadSongState(
      downloadSongStatus: downloadSongStatus != null ? downloadSongStatus() : this.downloadSongStatus,
      downloadSongs: downloadSongs != null ? downloadSongs() : this.downloadSongs,
      hasMoreSong: hasMoreSong != null ? hasMoreSong() : this.hasMoreSong,
      searchWord: searchWord != null ? searchWord() : this.searchWord,
    );
  }

  @override
  List<Object?> get props => [
    downloadSongStatus,
    downloadSongs,
    hasMoreSong,
    searchWord,
  ];

}