import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_world_app/components/play_bar.dart';
import 'package:music_world_app/components/song_tile.dart';
import 'package:music_world_app/screen/explore/bloc/album_bloc/album_bloc.dart';
import 'package:music_world_app/screen/explore/bloc/album_bloc/album_event.dart';
import 'package:music_world_app/screen/explore/bloc/album_bloc/album_state.dart';
import 'package:music_world_app/screen/explore/bloc/playlist_bloc/playlist_bloc.dart';
import 'package:music_world_app/screen/explore/bloc/playlist_bloc/playlist_event.dart';
import 'package:music_world_app/screen/singer/view/singer_info.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/navigate.dart';
import 'package:music_world_app/util/string.dart';
import 'package:music_world_app/util/text_style.dart';

import '../../../repositories/album_repository/models/album.dart';
import '../../../repositories/playlist_repository/models/playlist.dart';
import '../../app_bloc.dart';
import '../../app_event.dart';
import '../../song/view/song_page.dart';
import '../bloc/playlist_bloc/playlist_state.dart';

class Topic extends StatelessWidget {
  final String type;
  final Playlist? playlist;
  final Album? album;
  const Topic({
    Key? key, 
    required this.type,
    this.playlist,
    this.album,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlaylistPageBloc>(
          create: (_) => PlaylistPageBloc(),
        ),
        BlocProvider<AlbumPageBloc>(
          create: (_) => AlbumPageBloc(),
        ),
      ],
      child: TopicView(type: type, playlist: playlist, album: album,),
    );
  }
  
}

class TopicView extends StatefulWidget {
  final String type;
  final Playlist? playlist;
  final Album? album;
  const TopicView({
    Key? key,
    required this.type,
    this.playlist,
    this.album,
  }) : super(key: key);

  @override
  _TopicViewState createState() => _TopicViewState();
}


class _TopicViewState extends State<TopicView> {
  late ScrollController scrollController;

  void _scrollListener() {
    setState(() {
      if (scrollController.position.extentAfter < screenHeight / 5) {
        if (widget.type == "Playlist") {
          context.read<PlaylistPageBloc>().add(PlaylistPageLoadMoreSong(widget.playlist!.song));
        } else {
          context.read<AlbumPageBloc>().add(AlbumPageLoadMoreSong(widget.album!.song));
        }
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
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  widget.type == "Playlist" ?
                  widget.playlist!.picture : widget.album!.picture,),
                fit: BoxFit.cover,
              )
          ),
        ),
        Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigate.popPage(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.064 * screenWidth, 0.0985 * screenHeight, 0.064 * screenWidth, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //todo: playlist
                    PlayingBar(type: 1, onNextClick: () {}, onPrevClick: () {},),
                    SizedBox(height: screenHeight * 0.1638,),
                    Text(
                      widget.type == "Playlist" ? widget.playlist!.name : widget.album!.name,
                      style: title2.copyWith(color: textPrimaryColor),
                    ),
                    const SizedBox(height: 4,),
                    GestureDetector(
                      onTap: () {
                        if (widget.type != "Playlist") {
                          Navigate.pushPage(context, SingerInfo(artist: widget.album!.artist.elementAt(0)));
                        }
                      },
                      child: Text(
                        widget.type == "Playlist" ? playlistString : widget.album!.artist.elementAt(0).name,
                        style: subHeadline1.copyWith(color: textPrimaryColor),
                      ),
                    ),
                    SizedBox(height: 0.032 * screenHeight,),
                    Text(
                      widget.type == "Playlist" ? widget.playlist!.introduction : widget.album!.introduction,
                      style: lyric.copyWith(color: textPrimaryColor),
                    ),
                    SizedBox(height: 0.044 * screenHeight,),
                    Divider(color: neutralColor2, thickness: 1.5,),
                    widget.type == "Playlist" ?
                        PlaylistSong(playlist: widget.playlist!) :
                        AlbumSong(album: widget.album!),
                  ],
                ),
              ),
            )
        )
      ],
    );
  }
}

class PlaylistSong extends StatelessWidget {
  final Playlist playlist;
  const PlaylistSong({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistPageBloc, PlaylistPageState>(
      buildWhen: (previous, current) {
        if (previous.songs != current.songs) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        switch(state.songStatus) {
          case PlaylistPageStatus.initial:
            context.read<PlaylistPageBloc>().add(PlaylistPageSubscriptionRequest(playlist.song));
            return const Center();
          case PlaylistPageStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case PlaylistPageStatus.success:
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return CollectionListTile(
                  leadingAsset: state.songs.elementAt(index).picture,
                  songName: state.songs.elementAt(index).name,
                  artist: state.songs.elementAt(index).artist.elementAt(0).name,
                  number: index + 1,
                  onTap: () {
                    BlocProvider.of<HomeScreenBloc>(context).add(HomeOnClickSong(song: state.songs.elementAt(index),));
                    Navigate.pushPage(context, const SongPage());
                  },
                );
              },
              itemCount: state.songs.length,
            );
          case PlaylistPageStatus.failure:
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

class AlbumSong extends StatelessWidget {
  final Album album;
  const AlbumSong({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumPageBloc, AlbumPageState>(
      buildWhen: (previous, current) {
        if (previous.songs != current.songs) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        switch(state.songStatus) {
          case AlbumPageStatus.initial:
            context.read<AlbumPageBloc>().add(AlbumPageSubscriptionRequest(album.song));
            return const Center();
          case AlbumPageStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case AlbumPageStatus.success:
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return CollectionListTile(
                  leadingAsset: state.songs.elementAt(index).picture,
                  songName: state.songs.elementAt(index).name,
                  artist: state.songs.elementAt(index).artist.elementAt(0).name,
                  number: index + 1,
                  onTap: () {
                    BlocProvider.of<HomeScreenBloc>(context).add(HomeOnClickSong(song: state.songs.elementAt(index),));
                    Navigate.pushPage(context, const SongPage());
                  },
                );
              },
              itemCount: state.songs.length,
            );
          case AlbumPageStatus.failure:
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