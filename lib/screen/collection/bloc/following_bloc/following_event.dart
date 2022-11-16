import 'package:equatable/equatable.dart';

abstract class FollowingEvent extends Equatable {
  const FollowingEvent({
    required this.id,
  });

  final dynamic id;

  @override
  List<Object> get props => [
    id,
  ];
}

class FollowingSubscriptionRequest extends FollowingEvent {
  const FollowingSubscriptionRequest(dynamic id) : super(id: id);
}

class FollowingLoadMoreFollower extends FollowingEvent {
  const FollowingLoadMoreFollower(dynamic id) : super(id: id);
}


class FollowingSearchWordChange extends FollowingEvent {
  const FollowingSearchWordChange({required id, required this.keyWord,}) : super(id: id);

  final String keyWord;

  @override
  List<Object> get props => [
    id,
    keyWord,
  ];
}