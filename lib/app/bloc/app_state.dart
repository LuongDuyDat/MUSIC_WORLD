import 'dart:core';

import 'package:equatable/equatable.dart';

import '../../repositories/song_repository/models/song.dart';

enum HomeScreenStatus {initial, loading, success, failure}

List<Song> defaultList = [];

class HomeScreenState extends Equatable {
  const HomeScreenState({
    this.playingStatus = HomeScreenStatus.initial,
    this.isPlaying = false,
    this.playingSong = const [],
  });

  final HomeScreenStatus playingStatus;
  final bool isPlaying;
  final List<Song> playingSong;

  HomeScreenState copyWith({
    HomeScreenStatus Function()? playingStatus,
    bool Function()? isPlaying,
    List<Song> Function()? playingSong,
  }) {
    return HomeScreenState(
      playingStatus: playingStatus != null ? playingStatus() : this.playingStatus,
      isPlaying: isPlaying != null ? isPlaying() : this.isPlaying,
      playingSong: playingSong != null ? playingSong() : this.playingSong,
    );
  }

  @override
  List<Object?> get props => [
    playingStatus,
    isPlaying,
    playingSong,
  ];
}