import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_world_app/components/button.dart';
import 'package:music_world_app/components/search_bar.dart';
import 'package:music_world_app/components/song_tile.dart';
import 'package:music_world_app/repositories/playlist_repository/models/playlist.dart';
import 'package:music_world_app/repositories/playlist_repository/playlist_repository.dart';
import 'package:music_world_app/screen/collection/bloc/playlist_bloc/playlist_bloc.dart';
import 'package:music_world_app/screen/collection/bloc/playlist_bloc/playlist_event.dart';
import 'package:music_world_app/screen/collection/bloc/playlist_bloc/playlist_state.dart';
import 'package:music_world_app/screen/explore/view/topic.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/string.dart';

import '../../../util/globals.dart';
import '../../../util/navigate.dart';
import '../../../util/text_style.dart';

class CollectionPlaylist extends StatelessWidget {
  final dynamic type;
  const CollectionPlaylist({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Playlist> playlistBox = Hive.box<Playlist>('playlist');
    return BlocProvider(
      create: (_) => PlaylistBloc(playlistRepository: PlaylistRepository(playlistBox: playlistBox)),
      child: CollectionPlaylistView(type: type,),
    );
  }
}

class CollectionPlaylistView extends StatefulWidget {
  final dynamic type;
  const CollectionPlaylistView({Key? key, required this.type}) : super(key: key);

  @override
  _CollectionPlaylistView createState() => _CollectionPlaylistView();
}

class Playlists extends StatelessWidget {
  final dynamic type;
  const Playlists({Key? key, required this.type,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
        builder: (context, state) {
          switch (state.playlistStatus) {
            case PlaylistStatus.initial:
              context.read<PlaylistBloc>().add(PlaylistSubscriptionRequest(type == "me" ? account.key : type));
              return const Center();
            case PlaylistStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case PlaylistStatus.success:
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CollectionListTile(
                    leadingAsset: state.playlists.elementAt(index).picture,
                    songName: state.playlists.elementAt(index).name,
                    large: 40,
                    artist: state.playlists.elementAt(index).artist.elementAt(0).name,
                    onTap: () {
                      Navigate.pushPage(context, Topic(type: "Playlist", playlist: state.playlists.elementAt(index),));
                    },
                  );
                },
                itemCount: state.playlists.length,
              );
            case PlaylistStatus.failure:
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
        });
  }

}

class _CollectionPlaylistView extends State<CollectionPlaylistView> {
  late ScrollController _scrollController;

  void _scrollListener() {
    setState(() {
      if (_scrollController.position.extentAfter < 0.27 * screenHeight) {
        context.read<PlaylistBloc>().add(PlaylistLoadMorePlaylist(widget.type == "me" ? account.key : widget.type));
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
    context.read<PlaylistBloc>().add(PlaylistSearchWordChange(id: widget.type == "me" ? account.key : widget.type,
        keyWord: keyWord));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          playlistString,
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
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Playlists(type: widget.type),
                        widget.type == "me" ? SizedBox(height: 0.02 * screenHeight) : const Center(),
                        widget.type == "me" ? Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 0.4 * screenWidth,
                            decoration: BoxDecoration(
                              color: primaryColor,
                            ),
                            child: Button(
                              text: addNewPlaylistString,
                              radius: 0,
                              minimumSize: 0.049 * screenHeight,
                              type: subHeadline1,
                              onPressed: () => showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: const Color(0xFF292D39),
                                  title: Text(createPlaylistString, style: headlineBold1.copyWith(color: textPrimaryColor), textAlign: TextAlign.center,),
                                  content: TextField(
                                    style: lyric.copyWith(color: neutralColor2),
                                    cursorColor: primaryColor,
                                    decoration: InputDecoration(
                                      hintText: hintPlaylistTextField,
                                      hintStyle: lyric.copyWith(color: neutralColor2),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: neutralColor2),
                                      ),
                                      isDense: true,
                                    ),
                                  ),
                                  actions: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 0.032 * screenWidth),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 0.248 * screenWidth,
                                            child: TextButton(
                                              onPressed: () {
                                                Navigate.popPageResult(context, cancelString);
                                              },
                                              child: Text(
                                                cancelString,
                                                style: headlineMedium2.copyWith(color: primaryColor),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            child: Button(
                                              text: okString,
                                              radius: 0,
                                              minimumSize: 0.039 * screenHeight,
                                              type: headlineMedium2,
                                              onPressed: () {
                                                Navigate.popPageResult(context, okString);
                                              },
                                            ),
                                            width: 0.248 * screenWidth,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ) : const Center()
                      ],
                    ),
                  )
              )
          ),
        ],
      ),
    );
  }
}