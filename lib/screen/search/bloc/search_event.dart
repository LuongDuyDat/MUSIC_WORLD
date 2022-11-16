import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();


  @override
  List<Object> get props => [];
}

class SearchLoadMoreAlbumEvent extends SearchEvent {
  const SearchLoadMoreAlbumEvent();
}

class SearchLoadMorePlaylistEvent extends SearchEvent {
  const SearchLoadMorePlaylistEvent();
}

class SearchLoadMoreSongEvent extends SearchEvent {
  const SearchLoadMoreSongEvent();
}

class SearchLoadMoreArtistEvent extends SearchEvent {
  const SearchLoadMoreArtistEvent();
}

class SearchWordChange extends SearchEvent {
  const SearchWordChange({required this.keyWord,});

  final String keyWord;

  @override
  List<Object> get props => [
    keyWord,
  ];
}
