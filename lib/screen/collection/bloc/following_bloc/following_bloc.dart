import 'package:bloc/bloc.dart';
import 'package:music_world_app/repositories/artist_repository/artist_repository.dart';
import 'package:music_world_app/repositories/artist_repository/models/artist.dart';
import 'package:music_world_app/screen/collection/bloc/following_bloc/following_event.dart';
import 'package:music_world_app/screen/collection/bloc/following_bloc/following_state.dart';

class FollowingBloc extends Bloc<FollowingEvent, FollowingState> {
  FollowingBloc({
    required ArtistRepository artistRepository
  }) : _artistRepository = artistRepository,
        super(const FollowingState()) {
    on<FollowingSubscriptionRequest>(_onSubscriptionRequest);
    on<FollowingLoadMoreFollower>(_onLoadMoreFollower);
    on<FollowingSearchWordChange>(_onSearchWordChange);
  }

  final ArtistRepository _artistRepository;

  Future<void> _onSubscriptionRequest(
      FollowingSubscriptionRequest event,
      Emitter<FollowingState> emit,
      ) async {
    emit(state.copyWith(
      followingStatus: () => FollowingStatus.loading,
    ));
    await emit.forEach<Artist?>(
        _artistRepository.getFollowingArtist(event.id, 0, 10, ''),
        onData: (follower) {
          List<Artist> temp = List.from(state.followers);
          if (follower != null) {
            temp.add(follower);
          }
          return state.copyWith(followers: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            followingStatus: () => FollowingStatus.failure,
          );
        }
    );

    if (state.followingStatus != FollowingStatus.failure) {
      emit(
          state.copyWith(
              followingStatus: () => FollowingStatus.success
          ));
    }
  }

  Future<void> _onLoadMoreFollower(
      FollowingLoadMoreFollower event,
      Emitter<FollowingState> emit,
      ) async {

    if (state.hasMoreFollower == false) {
      return;
    }

    emit(state.copyWith(
      followingStatus: () => FollowingStatus.loading,
    ));

    int cnt = state.followers.length;

    await emit.forEach<Artist?>(
        _artistRepository.getFollowingArtist(event.id ,state.followers.length, state.followers.length + 5, state.searchWord,),
        onData: (follower) {
          List<Artist> temp = List.from(state.followers);
          if (follower != null) {
            temp.add(follower);
          }
          return state.copyWith(followers: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            followingStatus: () => FollowingStatus.failure,
          );
        }
    );

    if (state.followers.length < cnt + 5) {
      emit(
          state.copyWith(
              hasMoreFollower: () => false
          ));
    }

    if (state.followingStatus != FollowingStatus.failure) {
      emit(
          state.copyWith(
              followingStatus: () => FollowingStatus.success
          ));
    }
  }

  Future<void> _onSearchWordChange(
      FollowingSearchWordChange event,
      Emitter<FollowingState> emit,
      ) async {
    if (event.keyWord == state.searchWord) {
      return;
    }
    emit(state.copyWith(
      searchWord: () => event.keyWord,
    ));
    emit(state.copyWith(
      followingStatus: () => FollowingStatus.loading,
    ));
    state.followers.clear();
    await emit.forEach<Artist?>(
        _artistRepository.getFollowingArtist(event.id, 0, 10, state.searchWord,),
        onData: (follower) {
          List<Artist> temp = List.from(state.followers);
          if (follower != null) {
            temp.add(follower);
          }
          return state.copyWith(followers: () => temp);
        },
        onError: (_, __) {
          return state.copyWith(
            followingStatus: () => FollowingStatus.failure,
          );
        }
    );

    if (state.followingStatus != FollowingStatus.failure) {
      emit(
          state.copyWith(
              followingStatus: () => FollowingStatus.success
          ));
    }
  }
}