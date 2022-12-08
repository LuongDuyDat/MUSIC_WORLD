import 'dart:async';
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
import 'package:palette_generator/palette_generator.dart';

import '../../../util/string.dart';
import '../../../app/bloc/app_bloc.dart';
import '../../../app/bloc/app_event.dart';

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
    
    Future<Size> _calculateImageDimension(String image1) {
      Completer<Size> completer = Completer();
      Image image = Image.asset(image1);
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
              (ImageInfo image, bool synchronousCall) {
            var myImage = image.image;
            Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
            completer.complete(size);
          },
        ),
      );
      return completer.future;
    }
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
                return FutureBuilder<Size>(
                  future: _calculateImageDimension(state.newAlbums[index].picture),
                  builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
                    if (snapshot.hasData) {
                      double width = snapshot.data!.width;
                      double height = snapshot.data!.height;
                      return FutureBuilder<PaletteGenerator>(
                        future: PaletteGenerator.fromImageProvider(
                          AssetImage(state.newAlbums[index].picture),
                          size: Size(width, height),
                          region: Offset(width * 0.1, height * 0.8)
                          & Size(0.9 * width, 0.2 * height),
                        ),
                        builder: (BuildContext context, AsyncSnapshot<PaletteGenerator> snapshot) {
                          if (snapshot.hasData) {
                            PaletteGenerator paletteGenerator = snapshot.data!;
                            Color dominantColor = paletteGenerator.dominantColor?.color ?? Colors.black;
                            return InkWell(
                              child: ImageSlideBar(
                                asset: state.newAlbums[index].picture,
                                title: state.newAlbums[index].name,
                                singer: state.newAlbums[index].artist.elementAt(0).name,
                                color: dominantColor.computeLuminance() > 0.5 ? Colors.black : textPrimaryColor,
                              ),
                              onTap: () {
                                Navigate.pushPage(context, Topic(type: "Album", album: state.newAlbums[index],));
                              },
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: screenHeight / 15),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight / 15),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
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
                Song song = state.recentSongs.elementAt(index);
                return CollectionListTile(
                  leadingAsset: song.picture,
                  songName: song.name,
                  artist: song.artist.elementAt(0).name,
                  number: index + 1,
                  image: song.image,
                  onTap: () {
                    BlocProvider.of<HomeScreenBloc>(context).add(HomeOnClickSong(song: song,));
                    Navigate.pushPage(context, const SongPage(), dialog: true);
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
  final Color color;
  const ImageSlideBar({
    Key? key,
    required this.asset,
    required this.title,
    required this.singer,
    required this.color,
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
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.002,),
              Text(
                singer,
                style: bodyRegular3.copyWith(
                  color: color,
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