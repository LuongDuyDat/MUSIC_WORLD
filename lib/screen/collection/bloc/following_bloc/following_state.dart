import 'package:equatable/equatable.dart';

import '../../../../repositories/artist_repository/models/artist.dart';

enum FollowingStatus {initial, loading, success, failure}

class FollowingState extends Equatable {
  const FollowingState({
    this.followers = const[],
    this.followingStatus = FollowingStatus.initial,
    this.hasMoreFollower = true,
    this.searchWord = '',
  });

  final List<Artist> followers;
  final FollowingStatus followingStatus;
  final bool hasMoreFollower;
  final String searchWord;

  FollowingState copyWith({
    FollowingStatus Function()? followingStatus,
    List<Artist> Function()? followers,
    bool Function()? hasMoreFollower,
    String Function()? searchWord,
  }) {
    return FollowingState(
      followingStatus: followingStatus != null ? followingStatus() : this.followingStatus,
      followers: followers != null ? followers() : this.followers,
      hasMoreFollower: hasMoreFollower != null ? hasMoreFollower() : this.hasMoreFollower,
      searchWord: searchWord != null ? searchWord() : this.searchWord,
    );
  }

  @override
  List<Object?> get props => [
    followers,
    followingStatus,
    hasMoreFollower,
    searchWord,
  ];

}