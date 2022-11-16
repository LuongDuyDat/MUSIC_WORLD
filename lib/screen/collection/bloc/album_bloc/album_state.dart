import 'package:equatable/equatable.dart';
import 'package:music_world_app/repositories/album_repository/models/album.dart';

enum AlbumStatus {initial, loading, success, failure}

class AlbumState extends Equatable {
  const AlbumState({
    this.albums = const[],
    this.albumStatus = AlbumStatus.initial,
    this.hasMoreAlbum = true,
    this.searchWord = '',
  });

  final List<Album> albums;
  final AlbumStatus albumStatus;
  final bool hasMoreAlbum;
  final String searchWord;

  AlbumState copyWith({
    AlbumStatus Function()? albumStatus,
    List<Album> Function()? albums,
    bool Function()? hasMoreAlbum,
    String Function()? searchWord,
  }) {
    return AlbumState(
      albumStatus: albumStatus != null ? albumStatus() : this.albumStatus,
      albums: albums != null ? albums() : this.albums,
      hasMoreAlbum: hasMoreAlbum != null ? hasMoreAlbum() : this.hasMoreAlbum,
      searchWord: searchWord != null ? searchWord() : this.searchWord,
    );
  }

  @override
  List<Object?> get props => [
    albums,
    albumStatus,
    hasMoreAlbum,
    searchWord,
  ];

}