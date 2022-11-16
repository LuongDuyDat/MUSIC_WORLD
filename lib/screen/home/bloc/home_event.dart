import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeSubscriptionRequest extends HomeEvent {
  const HomeSubscriptionRequest();
}

class HomeLoadMoreRecentMusic extends HomeEvent {
  const HomeLoadMoreRecentMusic();
}