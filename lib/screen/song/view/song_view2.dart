import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_world_app/components/play_bar.dart';
import 'package:music_world_app/repositories/song_repository/models/song.dart';
import 'package:music_world_app/screen/app_bloc.dart';
import 'package:music_world_app/screen/app_state.dart';
import 'package:music_world_app/screen/singer/view/singer_info.dart';
import 'package:music_world_app/screen/song/bloc/song_bloc.dart';
import 'package:music_world_app/screen/song/bloc/song_event.dart';
import 'package:music_world_app/screen/song/bloc/song_state.dart';
import 'package:music_world_app/util/audio.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/navigate.dart';
import 'package:music_world_app/util/string.dart';
import 'package:music_world_app/util/text_style.dart';

import '../../../components/notifications.dart';


class SongView2 extends StatefulWidget {
  final void Function() onNextClick;
  final void Function() onPrevClick;
  const SongView2({Key? key, required this.onNextClick, required this.onPrevClick,}) : super(key: key);

  @override
  _SongView1State createState() => _SongView1State();
}

class _SongView1State extends State<SongView2> {
  double _currentSlideValue = 0;
  @override
  void initState() {
    super.initState();
  }


  String convertSecondtoMinutes(double s) {
    String result = "";
    int m = (s / 60).truncate();
    result += m.toString();
    int se = (s - m * 60).round();
    result += ":";
    if (se < 10) {
      result += "0";
    }
    result += se.toString();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: assetsAudioPlayer.currentPosition,
      builder: (context, asyncSnapshot) {
        final Duration? duration = asyncSnapshot.data;
        _currentSlideValue  = duration == null ? 0 : duration.inSeconds.toDouble();
        return BlocBuilder<HomeScreenBloc, HomeScreenState>(
          buildWhen: (previous, current) {
            return previous.playingSong != current.playingSong;
          },
          builder: (context, state) {
            Song song = state.playingSong.elementAt(state.playingSong.length - 1);
            return Column(
              children: [
                SizedBox(height: 0.062 * screenHeight,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth / 4),
                  child: Image.asset(song.picture, width: screenWidth / 2, height: screenWidth / 2, fit: BoxFit.cover,),
                ),
                SizedBox(height: 0.027 * screenHeight,),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 0.1 * screenHeight,
                  ),
                  child: Text(
                    song.name,
                    style: title2.copyWith(color: textPrimaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 0.01 * screenHeight,),
                InkWell(
                  child: Text(
                    song.artist.elementAt(0).name,
                    style: subHeadline1.copyWith(color: textPrimaryColor),
                  ),
                  onTap: () {
                    Navigate.pushPage(context, SingerInfo(artist: song.artist.elementAt(0),));
                  },
                ),
                SizedBox(height: 0.0246 * screenHeight,),
                SizedBox(
                  width: 0.64 * screenWidth,
                  child: Text(
                    "It is a long established fact that a reader",
                    style: lyric.copyWith(
                      color: primaryColor,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 0.0332 * screenHeight,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.138 * screenWidth),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: ImageIcon(
                          const AssetImage("assets/icons/share_icon.png"),
                          color: neutralColor1,
                          size: 20,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return const ShareModal();
                            },
                          );
                        },
                      ),
                      InkWell(
                        child: ImageIcon(
                          const AssetImage("assets/icons/add_playlist_icon.png"),
                          color: neutralColor1,
                          size: 20,
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const Notifications(
                                width: 200,
                                text: 'Add this song to My Playlist',
                              ).build(context));
                        },
                      ),
                      BlocBuilder<SongBloc, SongState>(
                          buildWhen: (pre, state) {
                            return pre.isFavorites != state.isFavorites;
                          },
                          builder: (context, state) {
                            context.read<SongBloc>().add(CheckFavorites(song: song));
                            return InkWell(
                              child: ImageIcon(
                                const AssetImage("assets/icons/favorite_icon.png"),
                                color: state.isFavorites == true ? Colors.red : neutralColor1,
                                size: 20,
                              ),
                              onTap: () {
                                if (state.isFavorites == false) {
                                  context.read<SongBloc>().add(AddFavoriteSong(song: song));
                                } else {
                                  context.read<SongBloc>().add(RemoveFavoriteSong(song: song));
                                }
                              },
                            );
                          }
                      ),
                      InkWell(
                        child: ImageIcon(
                          const AssetImage("assets/icons/download_icon.png"),
                          color: neutralColor1,
                          size: 20,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return const DownloadModal();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.01 * screenWidth, 0.025 * screenHeight, 0.01 * screenWidth, 0),
                  child: Slider(
                    value: _currentSlideValue,
                    max: assetsAudioPlayer.current.value!.audio.duration.inSeconds.toDouble(),
                    divisions: assetsAudioPlayer.current.value!.audio.duration.inSeconds,
                    onChanged: (double value) {
                      setState(() {
                        _currentSlideValue = value;
                        seek(_currentSlideValue.toInt());
                      });
                    },
                    thumbColor: primaryColor,
                    activeColor: primaryColor,
                    inactiveColor: neutralColor2,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0613 * screenWidth),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              convertSecondtoMinutes(_currentSlideValue),
                              style: lyric.copyWith(color: textPrimaryColor),
                            ),
                            Text(
                              convertSecondtoMinutes(assetsAudioPlayer.current.value!.audio.duration.inSeconds.toDouble()),
                              style: lyric.copyWith(color: textPrimaryColor),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.0246,),
                        PlayingBar(type: 0, onNextClick: widget.onNextClick, onPrevClick: widget.onPrevClick,),
                      ],
                    )
                ),
              ],
            );
          },
        );
      },
    );

  }

}

class DownloadModal extends StatelessWidget {
  const DownloadModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.3756 * screenHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(5, 202, 252, 0.2),
            Color.fromRGBO(14, 252, 160, 0.2),
          ],
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0394 * screenHeight, horizontal: 0.064 * screenWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              downloadToString,
              style: subHeadline1.copyWith(color: textPrimaryColor),
            ),
            SizedBox(height: 0.0468 * screenHeight,),
            Text(
              freeString,
              style: subHeadline1.copyWith(color: textPrimaryColor),
            ),
            SizedBox(height: 0.0123 * screenHeight,),
            Row(
              children: [
                Text(
                  throughoutString1,
                  style: lyric.copyWith(color: textPrimaryColor),
                ),
                SizedBox(width: 0.064 * screenWidth,),
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 0.004 * screenHeight),
                  child: Text(
                    freeString,
                    style: lyric.copyWith(color: const Color(0xFF20242F)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.0369 * screenHeight,),
            Text(
              vipAccountString,
              style: subHeadline1.copyWith(color: textPrimaryColor),
            ),
            SizedBox(height: 0.0123 * screenHeight,),
            Row(
              children: [
                Text(
                  throughoutString2,
                  style: lyric.copyWith(color: textPrimaryColor),
                ),
                SizedBox(width: 0.065 * screenWidth,),
                Container(
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2C94C),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 0.004 * screenHeight),
                  child: Text(
                    vipString,
                    style: lyric.copyWith(color: const Color(0xFF20242F)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.0123 * screenHeight,),
            Row(
              children: [
                Text(
                  losslessString,
                  style: lyric.copyWith(color: textPrimaryColor),
                ),
                SizedBox(width: 0.084 * screenWidth,),
                Container(
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2C94C),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 0.004 * screenHeight),
                  child: Text(
                    vipString,
                    style: lyric.copyWith(color: const Color(0xFF20242F)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShareModal extends StatelessWidget {
  const ShareModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.319 * screenHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(5, 202, 252, 0.2),
            Color.fromRGBO(14, 252, 160, 0.2),
          ],
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0394 * screenHeight, horizontal: 0.064 * screenWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shareToString,
              style: subHeadline1.copyWith(color: textPrimaryColor),
            ),
            SizedBox(height: 0.0246 * screenHeight,),
            Row(
              children: [
                Image.asset(
                  "assets/icons/facebook.png",
                  width: screenWidth * 0.064,
                  height: screenWidth * 0.064,
                ),
                SizedBox(width: 0.064 * screenWidth,),
                Text(
                  facebookString,
                  style: lyric.copyWith(color: textPrimaryColor),
                ),
              ],
            ),
            SizedBox(height: 0.0246 * screenHeight,),
            Row(
              children: [
                Image.asset(
                  "assets/icons/google-plus.png",
                  width: screenWidth * 0.064,
                  height: screenWidth * 0.064,
                ),
                SizedBox(width: 0.064 * screenWidth,),
                Text(
                  googleString,
                  style: lyric.copyWith(color: textPrimaryColor),
                ),
              ],
            ),
            SizedBox(height: 0.0246 * screenHeight,),
            Row(
              children: [
                Image.asset(
                  "assets/icons/twitter.png",
                  width: screenWidth * 0.064,
                  height: screenWidth * 0.064,
                ),
                SizedBox(width: 0.064 * screenWidth,),
                Text(
                  twitterString,
                  style: lyric.copyWith(color: textPrimaryColor),
                ),
              ],
            ),
            SizedBox(height: 0.0246 * screenHeight,),
            Row(
              children: [
                Image.asset(
                  "assets/icons/share_icon.png",
                  width: screenWidth * 0.064,
                  height: screenWidth * 0.064,
                ),
                SizedBox(width: 0.064 * screenWidth,),
                Text(
                  copyLinkString,
                  style: lyric.copyWith(color: textPrimaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

