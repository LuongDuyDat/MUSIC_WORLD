import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_world_app/components/search_bar.dart';
import 'package:music_world_app/components/song_tile.dart';
import 'package:music_world_app/repositories/artist_repository/artist_repository.dart';
import 'package:music_world_app/repositories/artist_repository/models/artist.dart';
import 'package:music_world_app/screen/collection/bloc/following_bloc/following_bloc.dart';
import 'package:music_world_app/screen/collection/bloc/following_bloc/following_event.dart';
import 'package:music_world_app/screen/singer/view/singer_info.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/string.dart';

import '../../../util/globals.dart';
import '../../../util/navigate.dart';
import '../../../util/text_style.dart';
import '../bloc/following_bloc/following_state.dart';

class CollectionArtist extends StatelessWidget {
  final dynamic type;
  const CollectionArtist({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Artist> artistBox = Hive.box<Artist>('artist');
    return BlocProvider(
      create: (_) => FollowingBloc(artistRepository: ArtistRepository(artistBox: artistBox)),
      child: CollectionArtistView(type: type,),
    );
  }
}

class CollectionArtistView extends StatelessWidget {
  final dynamic type;

  const CollectionArtistView({Key? key, required this.type,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onChangeSearchWord(String keyWord) {
      context.read<FollowingBloc>().add(FollowingSearchWordChange(id: type == "me" ? account.key : type,
          keyWord: keyWord));
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          padding: EdgeInsets.only(left: 0.0365 * screenWidth),
          icon: const Icon(Icons.arrow_back),
          iconSize: 24,
          onPressed: () {
            Navigate.popPage(context);
          },
        ),
        title: Text(
          artistString,
          style: title5.copyWith(color: textPrimaryColor),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.064 * screenWidth, 0, 0.064 * screenWidth, 0),
            child: Column(
              children: [
                SizedBox(height: 0.0246 * screenHeight,),
                SearchBar(width: 0.872 * screenWidth, onTextChange:  onChangeSearchWord,),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0.064 * screenWidth, 0.015 * screenHeight, 0.05 * screenWidth, 0),
              child: SizedBox(
                height: screenHeight * 0.78,
                child: Followers(type: type),
                /*ListView(
                  shrinkWrap: true,
                  children: [
                    CollectionListTile(
                      leadingAsset: "assets/images/activity1.png",
                      songName: "Maria Lucii",
                      number: 1,
                      large: 48,
                      onTap: () {
                        Navigate.pushPage(context, const SingerInfo());
                      },
                    ),
                    SizedBox(height: 0.0246 * screenHeight ,),
                    CollectionListTile(
                      leadingAsset: "assets/images/activity2.png",
                      songName: "Suzy Bae",
                      number: 2,
                      large: 48,
                      onTap: () {
                        Navigate.pushPage(context, const SingerInfo());
                      },
                    ),
                    SizedBox(height: 0.0246 * screenHeight ,),
                    CollectionListTile(
                      leadingAsset: "assets/images/activity3.png",
                      songName: "Marcia Luu",
                      number: 3,
                      large: 48,
                      onTap: () {
                        Navigate.pushPage(context, const SingerInfo());
                      },
                    ),
                    SizedBox(height: 0.0246 * screenHeight ,),
                    CollectionListTile(
                      leadingAsset: "assets/images/activity4.png",
                      songName: "Mino",
                      number: 4,
                      large: 48,
                      onTap: () {
                        Navigate.pushPage(context, const SingerInfo());
                      },
                    ),
                    SizedBox(height: 0.0246 * screenHeight ,),
                    CollectionListTile(
                      leadingAsset: "assets/images/activity5.png",
                      songName: "David Lamber",
                      number: 5,
                      large: 48,
                      onTap: () {
                        Navigate.pushPage(context, const SingerInfo());
                      },
                    ),
                    SizedBox(height: 0.0246 * screenHeight ,),
                    CollectionListTile(
                      leadingAsset: "assets/images/activity6.png",
                      songName: "Winner",
                      number: 6,
                      large: 48,
                      onTap: () {
                        Navigate.pushPage(context, const SingerInfo());
                      },
                    ),
                  ],
                ),*/
              )
          )
        ],
      ),
    );
  }
}

class Followers extends StatefulWidget {
  final dynamic type;

  const Followers({Key? key, required this.type,}) : super(key: key);

  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  late ScrollController _scrollController;

  void _scrollListener() {
    setState(() {
      if (_scrollController.position.extentAfter < 0.27 * screenHeight) {
        context.read<FollowingBloc>().add(FollowingLoadMoreFollower(widget.type == "me" ? account.key : widget.type));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowingBloc, FollowingState>(
      builder: (context, state) {
        switch (state.followingStatus) {
          case FollowingStatus.initial:
            context.read<FollowingBloc>().add(FollowingSubscriptionRequest(widget.type == "me" ? account.key : widget.type));
            return const Center();
          case FollowingStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case FollowingStatus.success:
            return ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 12,);
              },
              controller: _scrollController,
              itemBuilder: (context, index) {
                return CollectionListTile(
                  leadingAsset: state.followers.elementAt(index).picture,
                  songName: state.followers.elementAt(index).name,
                  number: index + 1,
                  large: 48,
                  onTap: () {
                    Navigate.pushPage(context, SingerInfo(artist: state.followers.elementAt(index),));
                  },
                );
              },
              itemCount: state.followers.length,
            );
          case FollowingStatus.failure:
            return Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight / 15),
              child: Center(
                child: Text(
                  somethingWrong,
                  style: title5.copyWith(color: textPrimaryColor),
                ),
              ),
            );
        }
      }
    );
  }

}