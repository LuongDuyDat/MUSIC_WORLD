import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_world_app/components/search_bar.dart';
import 'package:music_world_app/components/song_tile.dart';
import 'package:music_world_app/repositories/artist_repository/artist_repository.dart';
import 'package:music_world_app/screen/collection/bloc/download_bloc/download_bloc.dart';
import 'package:music_world_app/screen/collection/bloc/download_bloc/download_event.dart';
import 'package:music_world_app/screen/collection/bloc/download_bloc/download_state.dart';
import 'package:music_world_app/screen/song/view/song_page.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/string.dart';

import '../../../repositories/artist_repository/models/artist.dart';
import '../../../util/globals.dart';
import '../../../util/navigate.dart';
import '../../../util/text_style.dart';
import '../../../app/bloc/app_bloc.dart';
import '../../../app/bloc/app_event.dart';

class CollectionSong extends StatelessWidget {
  final dynamic type;
  const CollectionSong({Key? key, required this.type,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Artist> artistBox = Hive.box<Artist>("artist");
    return BlocProvider(
      create: (_) => DownloadSongBloc(artistRepository: ArtistRepository(artistBox: artistBox)),
      child: CollectionSongView(type: type,),
    );
  }



}

class CollectionSongView extends StatelessWidget {
  final dynamic type;
  const CollectionSongView({Key? key, required this.type,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onChangeSearchWord(String keyWord) {
      context.read<DownloadSongBloc>().add(DownloadSongSearchWordChange(id: type == "me" ? account.key : type,
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
          songString,
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
                SearchBar(width: 0.872 * screenWidth, onTextChange: onChangeSearchWord,),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0.064 * screenWidth, 0.015 * screenHeight, 0.05 * screenWidth, 0),
              child: SizedBox(
                height: screenHeight * 0.78,
                child: DownloadSong(type: type),
                /* ListView(
                  shrinkWrap: true,
                  children: const [
                    CollectionListTile(
                      leadingAsset: "assets/images/song1.png",
                      songName: "Nice For What",
                      artist: "Girl Generation",
                      number: 1,
                    ),
                    CollectionListTile(
                      leadingAsset: "assets/images/song2.png",
                      songName: "Where can I get some ?",
                      artist: "Suji Wong",
                      number: 2,
                    ),
                    CollectionListTile(
                      leadingAsset: "assets/images/song3.png",
                      songName: "Why do we use it ?",
                      artist: "Mercia",
                      number: 3,
                    ),
                    CollectionListTile(
                      leadingAsset: "assets/images/song4.png",
                      songName: "Turn Off The Light",
                      artist: "Mino",
                      number: 4,
                    ),
                    CollectionListTile(
                      leadingAsset: "assets/images/song5.png",
                      songName: "Where are you now ?",
                      artist: "Suji Wong",
                      number: 5,
                    ),
                    CollectionListTile(
                      leadingAsset: "assets/images/song1.png",
                      songName: "W",
                      artist: "DBSK",
                      number: 6,
                    ),
                  ],
                ),*/
              ),
          )
        ],
      ),
    );
  }

}

class DownloadSong extends StatefulWidget {
  final dynamic type;
  const DownloadSong({Key? key, required this.type,}) : super(key: key);

  @override
  _DownloadSongState createState() => _DownloadSongState();

}

class _DownloadSongState extends State<DownloadSong> {
  late ScrollController _scrollController;

  void _scrollListener() {
    setState(() {
      if (_scrollController.position.extentAfter < 0.27 * screenHeight) {
        context.read<DownloadSongBloc>().add(DownloadLoadMoreSong(widget.type == "me" ? account.key : widget.type));
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
    return BlocBuilder<DownloadSongBloc, DownloadSongState>(
        builder: (context, state) {
          switch (state.downloadSongStatus) {
            case DownloadSongStatus.initial:
              context.read<DownloadSongBloc>().add(DownloadSongSubscriptionRequest(widget.type == "me" ? account.key : widget.type));
              return const Center();
            case DownloadSongStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case DownloadSongStatus.success:
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12,);
                },
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return CollectionListTile(
                    leadingAsset: state.downloadSongs.elementAt(index).picture,
                    songName: state.downloadSongs.elementAt(index).name,
                    number: index + 1,
                    artist: state.downloadSongs.elementAt(index).artist.elementAt(0).name,
                    onTap: () {
                      BlocProvider.of<HomeScreenBloc>(context).add(HomeOnClickSong(song: state.downloadSongs.elementAt(index),));
                      Navigate.pushPage(context, const SongPage());
                    },
                  );
                },
                itemCount: state.downloadSongs.length,
              );
            case DownloadSongStatus.failure:
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