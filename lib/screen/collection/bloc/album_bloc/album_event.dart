import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent({
    required this.id,
  });

  final dynamic id;

  @override
  List<Object> get props => [
    id,
  ];
}

class AlbumSubscriptionRequest extends AlbumEvent {
  const AlbumSubscriptionRequest(dynamic id) : super(id: id);
}

class AlbumLoadMoreAlbum extends AlbumEvent {
  const AlbumLoadMoreAlbum(dynamic id) : super(id: id);
}


class AlbumSearchWordChange extends AlbumEvent {
  const AlbumSearchWordChange({required id, required this.keyWord,}) : super(id: id);

  final String keyWord;

  @override
  List<Object> get props => [
    id,
    keyWord,
  ];
}