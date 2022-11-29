import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:stack/stack.dart' as a;

import '../repositories/song_repository/models/song.dart';

enum HomeScreenStatus {initial, loading, success, failure}

class HomeScreenState extends Equatable {
  const HomeScreenState({
    this.playingStatus = HomeScreenStatus.initial,
    this.isPlaying = false,
    this.playingSong,
  });

  final HomeScreenStatus playingStatus;
  final bool isPlaying;
  final a.Stack<Song>? playingSong;

  HomeScreenState copyWith({
    HomeScreenStatus Function()? playingStatus,
    bool Function()? isPlaying,
    a.Stack<Song> Function()? playingSong,
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