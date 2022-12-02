import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_world_app/components/button.dart';
import 'package:music_world_app/components/image_type.dart';
import 'package:music_world_app/repositories/artist_repository/artist_repository.dart';
import 'package:music_world_app/repositories/artist_repository/models/artist.dart';
import 'package:music_world_app/screen/singer/bloc/singer_bloc.dart';
import 'package:music_world_app/screen/singer/bloc/singer_event.dart';
import 'package:music_world_app/screen/singer/bloc/singer_state.dart';
import 'package:music_world_app/screen/song/view/song_page.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/string.dart';
import 'package:music_world_app/util/text_style.dart';

import '../../../components/song_tile.dart';
import '../../../util/globals.dart';
import '../../../util/navigate.dart';
import '../../../app/bloc/app_bloc.dart';
import '../../../app/bloc/app_event.dart';
import '../../explore/view/topic.dart';

class SingerInfo extends StatelessWidget {
  final Artist artist;
  const SingerInfo({Key? key, required this.artist,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Artist> artistBox = Hive.box<Artist>('artist');
    return BlocProvider(
      create: (_) => SingerBloc(
        artistRepository: ArtistRepository(artistBox: artistBox),
        followingId: account.key,
        followerId: artist.key,
      ),
      child: SingerInfoView(artist: artist),
    );
  }
}

class SingerInfoView extends StatelessWidget {
  final Artist artist;

  const SingerInfoView({Key? key, required this.artist,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(/*"assets/images/singer_background.png"*/ artist.picture,),
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.064 * screenWidth, 0.022 * screenHeight, 0.064 * screenWidth, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist.name,
                    style: title2.copyWith(color: textPrimaryColor),
                  ),
                  SizedBox(height: 0.014 * screenHeight,),
                  const FollowButton(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.04267 * screenWidth, 0.0394 * screenHeight, 0.04267 * screenWidth, 0.0443 * screenHeight),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              artist.playlist.length.toString(),
                              style: subHeadline1.copyWith(color: textPrimaryColor),
                            ),
                            Text(
                              playlistString,
                              style: subHeadline1.copyWith(color: textPrimaryColor),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            BlocBuilder<SingerBloc, SingerState>(
                              buildWhen: (previous, current) {
                                if (previous.isFollowing != current.isFollowing) {
                                  return true;
                                }
                                return false;
                              },
                              builder: (context, state) {
                                return Text(
                                  artist.follower.length > 1000 ? (artist.follower.length ~/ 1000).toString() + " K" :
                                    artist.follower.length.toString(),
                                  style: subHeadline1.copyWith(color: textPrimaryColor),
                                );
                              },
                            ),
                            Text(
                              followerString,
                              style: subHeadline1.copyWith(color: textPrimaryColor),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              artist.following.length > 1000 ? (artist.following.length ~/ 1000).toString() + " K" :
                                artist.following.length.toString(),
                              style: subHeadline1.copyWith(color: textPrimaryColor),
                            ),
                            Text(
                              followingString,
                              style: subHeadline1.copyWith(color: textPrimaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    artist.introduction,
                    style: lyric.copyWith(color: textPrimaryColor),
                  ),
                  SizedBox(height: 0.03 * screenHeight,),
                  Divider(color: neutralColor2, thickness: 1.5,),
                  SizedBox(height: 0.03 * screenHeight,),
                  Text(
                    songString,
                    style: subHeadline1.copyWith(color: textPrimaryColor),
                  ),
                  SizedBox(
                    height: screenHeight * 0.24,
                    child: ListSong(artist: artist),
                  ),
                  SizedBox(height: 0.025 * screenHeight,),
                  Text(
                    albumString,
                    style: subHeadline1.copyWith(color: textPrimaryColor),
                  ),
                  SizedBox(height: 0.0246 * screenHeight,),
                  SizedBox(
                    width: 0.872 * screenWidth,
                    height: 0.2347 * screenWidth,
                    child: ListAlbum(artist: artist),
                  ),
                  SizedBox(height: 0.037 * screenHeight,)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

}

class ListSong extends StatefulWidget {
  final Artist artist;

  const ListSong({Key? key, required this.artist,}) : super(key: key);

  @override
  _ListSongState createState() => _ListSongState();

}

class _ListSongState extends State<ListSong> {
  late ScrollController _scrollController;

  void _scrollListener() {
    setState(() {
      if (_scrollController.position.extentAfter < 0.08 * screenHeight) {
        context.read<SingerBloc>().add(SingerLoadMoreSong(songs: widget.artist.song));
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
    return BlocBuilder<SingerBloc, SingerState>(
      buildWhen: (previous, current) {
        if (previous.songs != current.songs) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, index) {
            return CollectionListTile(
              leadingAsset: widget.artist.song.elementAt(index).picture,
              songName: widget.artist.song.elementAt(index).name,
              artist: widget.artist.song.elementAt(index).artist.elementAt(0).name,
              onTap: () {
                BlocProvider.of<HomeScreenBloc>(context).add(HomeOnClickSong(song: widget.artist.song.elementAt(index),));
                Navigate.pushPage(context, const SongPage(), dialog: true);
              },
            );
          },
          itemCount: widget.artist.song.length,
        );
      },
    );
  }

}

class ListAlbum extends StatefulWidget {
  final Artist artist;

  const ListAlbum({Key? key, required this.artist,}) : super(key: key);

  @override
  _ListAlbumState createState() => _ListAlbumState();

}

class _ListAlbumState extends State<ListAlbum> {
  late ScrollController _scrollController;

  void _scrollListener() {
    setState(() {
      if (_scrollController.position.extentAfter < 0.08 * screenHeight) {
        context.read<SingerBloc>().add(SingerLoadMoreAlbum(albums: widget.artist.album));
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
    return BlocBuilder<SingerBloc, SingerState>(
      buildWhen: (previous, current) {
        if (previous.albums != current.albums) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) {
            return SizedBox(width: 0.04267 * screenWidth);
          },
          itemBuilder: (context, index) {
            return ImageType(
              asset: widget.artist.album.elementAt(index).picture,
              type: widget.artist.album.elementAt(index).name,
              width: 0.2347 * screenWidth,
              height: 0.2347 * screenWidth,
              onTap: () {
                Navigate.pushPage(context, Topic(type: "Album", album: widget.artist.album.elementAt(index),));
              },
            );
          },
          itemCount: widget.artist.album.length,
        );
      },
    );
  }

}

class FollowButton extends StatelessWidget {
  const FollowButton({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingerBloc, SingerState>(
      builder: (context, state) {
        return SizedBox(
          width: 0.256 * screenWidth,
          child: Button(
            text: state.isFollowing ? unfollowingString : followString,
            radius: 0,
            minimumSize: screenHeight * 0.0345,
            type: bodyRegular3,
            onPressed: () {
              context.read<SingerBloc>().add(const SingerClickFollowButton());
            },
          ),
        );
      },
    );
  }

}