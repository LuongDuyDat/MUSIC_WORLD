import 'package:equatable/equatable.dart';

enum HomeScreenStatus {initial, loading, success, failure}

class HomeScreenState extends Equatable {
  const HomeScreenState({
    this.playingStatus = HomeScreenStatus.initial,
    this.isPlaying = false,
  });

  final HomeScreenStatus playingStatus;
  final bool isPlaying;

  HomeScreenState copyWith({
    HomeScreenStatus Function()? playingStatus,
    bool Function()? isPlaying,
  }) {
    return HomeScreenState(
      playingStatus: playingStatus != null ? playingStatus() : this.playingStatus,
      isPlaying: isPlaying != null ? isPlaying() : this.isPlaying,
    );
  }

  @override
  List<Object?> get props => [
    playingStatus,
    isPlaying,
  ];
}