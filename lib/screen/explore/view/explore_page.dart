import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_world_app/screen/collection/view/collection_playlist.dart';
import 'package:music_world_app/screen/explore/bloc/explore_bloc.dart';
import 'package:music_world_app/screen/explore/bloc/explore_event.dart';
import 'package:music_world_app/screen/explore/bloc/explore_state.dart';
import 'package:music_world_app/screen/explore/view/topic.dart';
import 'package:music_world_app/screen/song/view/song_page.dart';
import 'package:music_world_app/util/navigate.dart';

import '../../../components/image_type.dart';
import '../../../components/song_tile.dart';
import '../../../repositories/song_repository/models/song.dart';
import '../../../repositories/song_repository/song_repository.dart';
import '../../../util/colors.dart';
import '../../../util/globals.dart';
import '../../../util/string.dart';
import '../../../util/text_style.dart';
import '../../../app/bloc/app_bloc.dart';
import '../../../app/bloc/app_event.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Song> songBox = Hive.box<Song>('song');
    return BlocProvider(
      create: (_) => ExploreBloc(songRepository: SongRepository(songBox:songBox,)),
      child: const ExploreView(),
    );

  }
}

class ExploreView extends StatelessWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: screenWidth * 0.064),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                chartString,
                style: title5.copyWith(color: textPrimaryColor),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.064),
          child: Container(
            height: 0.39 * screenHeight,
            decoration: const BoxDecoration(
              color: Color(0xFF1D1937),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 0.032 * screenWidth),
              child: const SongChart(),
            )
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.04, left: screenWidth * 0.064, right: screenWidth * 0.064),
          child: SizedBox(
            height: 0.2266 * screenHeight,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      topicString,
                      style: title5.copyWith(color: textPrimaryColor),
                    ),
                    InkWell(
                      child: Text(
                        viewAllString,
                        style: bodyRegular3.copyWith(color: textPrimaryColor),
                      ),
                      onTap: () {
                        Navigate.pushPage(context, const CollectionPlaylist(type: "other",));
                      },
                    )
                  ],
                ),
                SizedBox(height: screenHeight * 0.0246,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: ImageType(
                        asset: "assets/images/hip_hop.png",
                        type: "HipHop",
                        width: 0.256 * screenWidth,
                        height: 0.075 * screenHeight,
                        onTap: () {
                          Navigate.pushPage(context, const Topic(type: "Playlist",));
                        },
                      ),
                      onTap: () {
                        Navigate.pushPage(context, const Topic(type: "Playlist",));
                      },
                    ),
                    InkWell(
                      child: ImageType(
                        asset: "assets/images/pop.png",
                        type: "POP",
                        width: 0.256 * screenWidth,
                        height: 0.075 * screenHeight,
                        onTap: () {
                          Navigate.pushPage(context, const Topic(type: "Playlist",));
                        },
                      ),
                      onTap: () {
                        Navigate.pushPage(context, const Topic(type: "Playlist",));
                      },
                    ),
                    InkWell(
                      child: ImageType(
                        asset: "assets/images/jazz.png",
                        type: "Jazz",
                        width: 0.256 * screenWidth,
                        height: 0.075 * screenHeight,
                        onTap: () {
                          Navigate.pushPage(context, const Topic(type: "Playlist",));
                        },
                      ),
                      onTap: () {
                        Navigate.pushPage(context, const Topic(type: "Playlist",));
                      },
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.0197,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: ImageType(
                        asset: "assets/images/danc.png",
                        type: "Danc",
                        width: 0.256 * screenWidth,
                        height: 0.075 * screenHeight,
                        onTap: () {
                          Navigate.pushPage(context, const Topic(type: "Playlist",));
                        },
                      ),
                      onTap: () {
                        Navigate.pushPage(context, const Topic(type: "Playlist",));
                      },
                    ),
                    InkWell(
                      child: ImageType(
                        asset: "assets/images/ballad.png",
                        type: "Ballad",
                        width: 0.256 * screenWidth,
                        height: 0.075 * screenHeight,
                        onTap: () {
                          Navigate.pushPage(context, const Topic(type: "Playlist",));
                        },
                      ),
                      onTap: () {
                        Navigate.pushPage(context, const Topic(type: "Playlist",));
                      },
                    ),
                    InkWell(
                      child: ImageType(
                        asset: "assets/images/R_B.png",
                        type: "R&B",
                        width: 0.256 * screenWidth,
                        height: 0.075 * screenHeight,
                        onTap: () {
                          Navigate.pushPage(context, const Topic(type: "Playlist",));
                        },
                      ),
                      onTap: () {
                        Navigate.pushPage(context, const Topic(type: "Playlist",));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class SongChart extends StatefulWidget {
  const SongChart({Key? key}) : super(key: key);

  @override
  _SongChartState createState() => _SongChartState();

}

class _SongChartState extends State<SongChart> {
  late ScrollController _scrollController;

  void _scrollListener() {
    setState(() {
      if (_scrollController.position.extentAfter < 0.1 * screenHeight) {
        context.read<ExploreBloc>().add(const ExploreLoadMoreMusicChart());
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
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        switch(state.songChartStatus) {
          case ExploreStatus.initial:
            context.read<ExploreBloc>().add(const ExploreSubscriptionRequest());
            return const Center();
          case ExploreStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ExploreStatus.success:
            return ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                return CollectionListTile(
                  leadingAsset: state.songChart.elementAt(index).picture,
                  songName: state.songChart.elementAt(index).name,
                  artist: state.songChart.elementAt(index).artist.elementAt(0).name,
                  number: index + 1,
                  onTap: () {
                    BlocProvider.of<HomeScreenBloc>(context).add(HomeOnClickSong(song: state.songChart.elementAt(index),));
                    Navigate.pushPage(context, const SongPage(), dialog: true);
                  },
                );
              },
              itemCount: state.songChart.length,
            );
          case ExploreStatus.failure:
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
      },
    );
  }
}