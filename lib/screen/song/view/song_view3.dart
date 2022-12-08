import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:flutter_lyric/lyrics_reader_widget.dart';
import 'package:music_world_app/app/bloc/app_bloc.dart';
import 'package:music_world_app/app/bloc/app_state.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/string.dart';
import 'package:music_world_app/util/text_style.dart';

import '../../../components/play_bar.dart';
import '../../../components/ui_netease.dart';
import '../../../repositories/song_repository/models/song.dart';
import '../../../util/audio.dart';

class SongView3 extends StatefulWidget {
  const SongView3({Key? key,}) : super(key: key);

  @override
  _SongView3State createState() => _SongView3State();
}

class _SongView3State extends State<SongView3> {

  double _currentSlideValue = 0;
  int _playProgress = 0;

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

  Future<String> getString(String lyricsPath, Uint8List? localLyricsPath) async {
    String content = '';
    if (localLyricsPath == null) {
      content = await rootBundle.loadString(lyricsPath);
    } else {
      content = String.fromCharCodes(localLyricsPath);
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: assetsAudioPlayer.currentPosition,
      builder: (context, asyncSnapshot) {
        final Duration? duration = asyncSnapshot.data;
        _currentSlideValue = duration == null ? 0 : duration.inSeconds.toDouble();
        _playProgress = duration == null ? 0 : duration.inMilliseconds.toInt();
        return BlocBuilder<HomeScreenBloc, HomeScreenState>(
          buildWhen: (previous, current) {
            return previous.playingSong != current.playingSong;
          },
          builder: (context, state) {
            Song song = state.playingSong.elementAt(state.playingSong.length - 1);
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.22 * screenWidth, 0.0443 * screenHeight, 0.22 * screenWidth, 0),
                  child: Column(
                    children: [
                      Text(
                        lyricString,
                        style: bodyRegular1.copyWith(color: textPrimaryColor),
                      ),
                      SizedBox(height: 0.0345 * screenHeight,),
                      FutureBuilder<String>(
                        builder: (BuildContext context, AsyncSnapshot<String> asyncData) {
                          if (asyncData.hasData) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                buildReaderWidget(asyncData.data!, _playProgress),
                              ],
                            );
                          }
                          return const Center();
                        },
                        future: getString(song.lyricPath, song.deviceLyricPath,),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.01 * screenWidth, 0.025 * screenHeight, 0.01 * screenWidth, 0),
                  child: Slider(
                    value: _currentSlideValue,
                    max: assetsAudioPlayer.current.valueOrNull != null ? assetsAudioPlayer.current.value!.audio.duration.inSeconds.toDouble() : 0,
                    divisions: assetsAudioPlayer.current.valueOrNull != null ? assetsAudioPlayer.current.value!.audio.duration.inSeconds : 1,
                    onChanged: (double value) {
                      setState(() {
                        _currentSlideValue = value;
                        _playProgress = (value * 1000).toInt();
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
                              assetsAudioPlayer.current.valueOrNull != null
                                  ? convertSecondtoMinutes(assetsAudioPlayer.current.value!.audio.duration.inSeconds.toDouble())
                                  : "0:00",
                              style: lyric.copyWith(color: textPrimaryColor),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.0246,),
                        PlayingBar(type: 0, playlist: state.playingPlaylist, album: state.playingAlbum,),
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

StreamBuilder buildReaderWidget(String normalLyric, int playProgress) {
  var lyricModel = LyricsModelBuilder.create()
      .bindLyricToMain(normalLyric)
      .getModel();

  var lyricUI = UiNetease();

  return StreamBuilder<bool>(
    stream: assetsAudioPlayer.isPlaying,
    builder: (context, snapshot) {
      bool playing = snapshot.data ?? false;
      return LyricsReader(
        padding: EdgeInsets.symmetric(horizontal: 0.01 * screenWidth, vertical: 0),
        model: lyricModel,
        position: playProgress,
        lyricUi: lyricUI,
        playing: playing,
        size: Size(double.infinity, screenHeight * 0.45),
        emptyBuilder: () => Center(
          child: Text(
            "No lyrics",
            style: lyricUI.getOtherMainTextStyle(),
          ),
        ),
      );
    },
  );
}