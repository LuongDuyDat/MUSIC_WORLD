import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();


  @override
  List<Object> get props => [];
}

class SearchSubscriptionRequest extends SearchEvent {
  const SearchSubscriptionRequest();
}

class SearchAddRecentSearch extends SearchEvent {
  const SearchAddRecentSearch({required this.content});

  final String content;

  @override
  List<Object> get props => [content,];
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
