import 'package:equatable/equatable.dart';

abstract class DownloadSongEvent extends Equatable {
  const DownloadSongEvent({
    required this.id,
  });

  final dynamic id;

  @override
  List<Object> get props => [
    id,
  ];
}

class DownloadSongSubscriptionRequest extends DownloadSongEvent {
  const DownloadSongSubscriptionRequest(dynamic id) : super(id: id);
}

class DownloadLoadMoreSong extends DownloadSongEvent {
  const DownloadLoadMoreSong(dynamic id) : super(id: id);
}


class DownloadSongSearchWordChange extends DownloadSongEvent {
  const DownloadSongSearchWordChange({required id, required this.keyWord,}) : super(id: id);

  final String keyWord;

  @override
  List<Object> get props => [
    id,
    keyWord,
  ];
}