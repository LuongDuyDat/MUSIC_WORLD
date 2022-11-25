import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_world_app/components/song_tile.dart';
import 'package:music_world_app/repositories/album_repository/album_repository.dart';
import 'package:music_world_app/repositories/album_repository/models/album.dart';
import 'package:music_world_app/repositories/song_repository/models/song.dart';
import 'package:music_world_app/repositories/song_repository/song_repository.dart';
import 'package:music_world_app/screen/collection/view/collection_album.dart';
import 'package:music_world_app/screen/explore/view/topic.dart';
import 'package:music_world_app/screen/home/bloc/home_bloc.dart';
import 'package:music_world_app/screen/home/bloc/home_event.dart';
import 'package:music_world_app/screen/home/bloc/home_state.dart';
import 'package:music_world_app/screen/song/view/song_page.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/navigate.dart';
import 'package:music_world_app/util/text_style.dart';

import '../../../util/string.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Album> albumBox = Hive.box<Album>('album');
    Box<Song> songBox = Hive.box<Song>('song');
    return BlocProvider(
      create: (_) => HomeBloc(albumRepository: AlbumRepository(albumBox: albumBox,),
          songRepository: SongRepository(songBox:songBox,)),
      child: const HomeView(),
    );

  }

}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double recentMusicHeight = 0.3906;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: screenWidth * 0.064),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                newAlbumString,
                style: title5.copyWith(color: textPrimaryColor),
              ),
              InkWell(
                child: Text(
                  viewAllString,
                  style: bodyRegular3.copyWith(color: textPrimaryColor),
                ),
                onTap: () {
                  Navigate.pushPage(context, const CollectionAlbum(type: "new",));
                },
              ),
            ],
          ),
        ),
        const NewAlbumSlider(),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.049, left: screenWidth * 0.064),
            child: Text(
              recentMusicString,
              style: title5.copyWith(color: textPrimaryColor),
            ),
          ),
        ),
        Container(
          height: recentMusicHeight * screenHeight,
          padding: EdgeInsets.only(left: screenWidth * 0.064),
          child: RecentSongList(height: recentMusicHeight,),
        ),
      ],
    );
  }

}

class NewAlbumSlider extends StatelessWidget {
  const NewAlbumSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        switch(state.newAlbumStatus) {
          case HomeStatus.initial:
            context.read<HomeBloc>().add(const HomeSubscriptionRequest());
            return const Center();
          case HomeStatus.loading:
            return Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight / 15),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          case HomeStatus.success:
            //print(state.newAlbums.length);
            return CarouselSlider.builder(
              options: CarouselOptions(
                height: 0.2 * screenHeight,
                initialPage: 1,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
                viewportFraction: 0.6,
              ),
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return InkWell(
                  child: ImageSlideBar(asset: state.newAlbums[index].picture, title: state.newAlbums[index].name,
                    singer: state.newAlbums[index].artist.elementAt(0).name,),
                  onTap: () {
                    Navigate.pushPage(context, Topic(type: "Album", album: state.newAlbums[index],));
                  },
                );
              },
              itemCount: state.newAlbums.length,
            );
          case HomeStatus.failure:
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

class RecentSongList extends StatefulWidget {
  const RecentSongList({Key? key, required this.height}) : super(key: key);

  final double height;

  @override
  _RecentSongListState createState() => _RecentSongListState();

}

class _RecentSongListState extends State<RecentSongList> {
  late ScrollController scrollController;

  void _scrollListener() {
    setState(() {
      if (scrollController.position.extentAfter < widget.height / 3 * screenHeight) {
        context.read<HomeBloc>().add(const HomeLoadMoreRecentMusic());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        switch(state.recentSongStatus) {
          case HomeStatus.initial:
            return const Center();
          case HomeStatus.loading:
            return Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight / 15),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          case HomeStatus.success:
            return ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) {
                return CollectionListTile(
                  leadingAsset: state.recentSongs.elementAt(index).picture,
                  songName: state.recentSongs.elementAt(index).name,
                  artist: state.recentSongs.elementAt(index).artist.elementAt(0).name,
                  number: index + 1,
                  onTap: () {
                    Navigate.pushPage(context, SongPage(song: state.recentSongs.elementAt(index)));
                  },
                );
              },
              itemCount: state.recentSongs.length,
            );
          case HomeStatus.failure:
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

class ImageSlideBar extends StatelessWidget {
  final String asset;
  final String title;
  final String singer;
  const ImageSlideBar({
    Key? key,
    required this.asset,
    required this.title,
    required this.singer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(asset, width: screenWidth * 0.452, height: screenWidth * 0.452, fit: BoxFit.cover,),
        Positioned(
          left: screenWidth * 0.04626,
          bottom: screenHeight * 0.008,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: bodyRegular3.copyWith(
                  color: textPrimaryColor,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: neutralColor3,
                      blurRadius: 8,
                      offset: const Offset(4.0, 4.0),
                    )
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.002,),
              Text(
                singer,
                style: bodyRegular3.copyWith(
                  color: textPrimaryColor,
                  shadows: [
                    Shadow(
                      color: neutralColor3,
                      blurRadius: 20,
                      offset: const Offset(8.0, 8.0),
                    )
                  ],
                ),

              ),
            ],
          ),
        )
      ],
    );
  }

}