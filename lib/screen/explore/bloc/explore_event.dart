import 'package:equatable/equatable.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object> get props => [];
}

class ExploreSubscriptionRequest extends ExploreEvent {
  const ExploreSubscriptionRequest();
}

class ExploreLoadMoreMusicChart extends ExploreEvent {
  const ExploreLoadMoreMusicChart();
}