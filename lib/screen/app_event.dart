import 'package:equatable/equatable.dart';

abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object> get props => [];
}

class HomeChangeIsPlaying extends HomeScreenEvent {
  const HomeChangeIsPlaying({required this.isPlaying,});

  final bool isPlaying;

  @override
  List<Object> get props => [isPlaying];
}