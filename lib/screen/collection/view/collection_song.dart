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
import 'package:music_world_app/screen/upload_song/view/upload_song.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/string.dart';

import '../../../components/button.dart';
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

class CollectionSongView extends StatefulWidget {
  final dynamic type;
  const CollectionSongView({Key? key, required this.type,}) : super(key: key);

  @override
  _CollectionSongViewState createState() => _CollectionSongViewState();
}

class DownloadSong extends StatelessWidget {
  final dynamic type;
  const DownloadSong({Key? key, required this.type,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadSongBloc, DownloadSongState>(
        builder: (context, state) {
          switch (state.downloadSongStatus) {
            case DownloadSongStatus.initial:
              context.read<DownloadSongBloc>().add(DownloadSongSubscriptionRequest(type == "me" ? account.key : type));
              return const Center();
            case DownloadSongStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case DownloadSongStatus.success:
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CollectionListTile(
                    leadingAsset: state.downloadSongs.elementAt(index).picture,
                    songName: state.downloadSongs.elementAt(index).name,
                    number: index + 1,
                    artist: state.downloadSongs.elementAt(index).artist.elementAt(0).name,
                    image: state.downloadSongs.elementAt(index).image,
                    onTap: () {
                      BlocProvider.of<HomeScreenBloc>(context).add(HomeOnClickSong(song: state.downloadSongs.elementAt(index),));
                      Navigate.pushPage(context, const SongPage(), dialog: true);
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

class _CollectionSongViewState extends State<CollectionSongView> {
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

  void onChangeSearchWord(String keyWord) {
    context.read<DownloadSongBloc>().add(DownloadSongSearchWordChange(id: widget.type == "me" ? account.key : widget.type,
        keyWord: keyWord));
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                children: [
                  DownloadSong(type: widget.type),
                  widget.type == "me" ? SizedBox(height: 0.02 * screenHeight) : const Center(),
                  widget.type == "me" ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 0.4 * screenWidth,
                      decoration: BoxDecoration(
                        color: primaryColor,
                      ),
                      child: Button(
                          text: uploadSongString,
                          radius: 0,
                          minimumSize: 0.049 * screenHeight,
                          type: subHeadline1,
                          onPressed: () {
                            Navigate.pushPage(context, const UploadSong());
                          }
                      ),
                    ),
                  ) : const Center()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}