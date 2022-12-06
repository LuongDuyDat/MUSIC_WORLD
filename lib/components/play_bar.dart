import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_world_app/app/bloc/app_event.dart';
import 'package:music_world_app/repositories/playlist_repository/models/playlist.dart' as my;
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';

import '../app/bloc/app_bloc.dart';
import '../repositories/album_repository/models/album.dart';

class PlayingBar extends StatefulWidget {
  final int type;
  final my.Playlist? playlist;
  final Album? album;
  const PlayingBar({
    Key? key,
    required this.type,
    this.playlist,
    this.album,
  }) : super(key: key);

  @override
  _PlayingBarState createState() => _PlayingBarState();
}

class _PlayingBarState extends State<PlayingBar> {

  bool? _isPlayingTopic;

  @override
  void initState() {
    super.initState();
    if (widget.playlist == null && widget.album == null) {
      _isPlayingTopic = null;
      return;
    }
    if (widget.playlist != null && assetsAudioPlayer.getCurrentAudioextra["playlist"] != null
        && widget.playlist == assetsAudioPlayer.getCurrentAudioextra["playlist"]) {
      _isPlayingTopic = true;
      return;
    }
    if (widget.album != null && assetsAudioPlayer.getCurrentAudioextra["album"] != null
        && widget.album == assetsAudioPlayer.getCurrentAudioextra["album"]) {
      _isPlayingTopic = true;
      return;
    }
    _isPlayingTopic = false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: assetsAudioPlayer.isPlaying,
      builder: (context, asyncSnapshot) {
        bool isPlaying = asyncSnapshot.data ?? false;
        return StreamBuilder<LoopMode>(
          stream: assetsAudioPlayer.loopMode,
          builder: (context, asyncSnapshot) {
            LoopMode loop = asyncSnapshot.data ?? LoopMode.none;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.type == 0 ?
                InkWell(
                  child: ImageIcon(
                    const AssetImage("assets/icons/shuffle_icon.png"),
                    color: shuffleSingle == 0 ? const Color(0xFFEEEEEE) : primaryColor,
                  ),
                  onTap: () {
                    setState(() {
                      if (shuffleSingle == 0) {
                        shuffleSingle = 1;
                      } else {
                        shuffleSingle = 0;
                      }
                    });
                  },
                ) : const Center(),
                InkWell(
                  child: const ImageIcon(
                    AssetImage("assets/icons/skip_prev_icon.png"),
                    color: Color(0xFFEEEEEE),
                  ),
                  onTap: () {
                    if (widget.type == 0) {
                      BlocProvider.of<HomeScreenBloc>(context).add(const HomePrevSongClick());
                    } else if (widget.type == 1 && _isPlayingTopic == true) {
                      BlocProvider.of<HomeScreenBloc>(context).add(const HomePrevTopicClick());
                    }
                  },
                ),
                InkWell(
                  child: widget.type == 0 ?
                  CircleAvatar(
                    backgroundColor: const Color(0xFFCBFB5E),
                    radius: 36,
                    child: Icon(
                      isPlaying ? Icons.pause_outlined : Icons.play_arrow_outlined,
                      size: 50,
                    ),
                  ) :
                  Container(
                    width: 73,
                    height: 73,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: textPrimaryColor,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(36.5)),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      isPlaying && _isPlayingTopic != null &&_isPlayingTopic == true ? Icons.pause : Icons.play_arrow,
                      size: 50,
                      color: const Color(0xFFEEEEEE),
                    ),
                  ),
                  onTap: () {
                    if (widget.type == 0) {
                      assetsAudioPlayer.playOrPause();
                    } else {
                      if (_isPlayingTopic != null) {
                        if (_isPlayingTopic == true) {
                          assetsAudioPlayer.playOrPause();
                        } else {
                          if (widget.playlist != null) {
                            setState(() {
                              _isPlayingTopic = true;
                            });
                            BlocProvider.of<HomeScreenBloc>(context).add(HomePlayPlaylist(playlist: widget.playlist!));
                          } else {
                            setState(() {
                              _isPlayingTopic = true;
                            });
                            BlocProvider.of<HomeScreenBloc>(context).add(HomePlayAlbum(album: widget.album!,));
                          }
                        }
                      }
                    }
                  },
                ),
                InkWell(
                  child: const ImageIcon(
                    AssetImage("assets/icons/skip_next_icon.png"),
                    color: Color(0xFFEEEEEE),
                  ),
                  onTap: () {
                    if (widget.type == 0) {
                      BlocProvider.of<HomeScreenBloc>(context).add(const HomeNextSongClick());
                    } else if (widget.type == 1 && _isPlayingTopic == true) {
                      BlocProvider.of<HomeScreenBloc>(context).add(const HomeNextTopicClick());
                    }
                  },
                ),
                widget.type == 0 ?
                InkWell(
                  child: ImageIcon(
                    const AssetImage("assets/icons/loop_icon.png"),
                    color: loop != LoopMode.single ? const Color(0xFFEEEEEE) : primaryColor,
                  ),
                  onTap: () {
                    //print(1);
                    if (loop == LoopMode.none) {
                      assetsAudioPlayer.setLoopMode(LoopMode.single);
                      if (shuffleSingle == 1) {
                        setState(() {
                          shuffleSingle = 0;
                        });
                      }
                    } else {
                      assetsAudioPlayer.toggleLoop();
                    }
                  },
                ) : const Center(),
              ],
            );
          },
        );
      },
    );
  }

}