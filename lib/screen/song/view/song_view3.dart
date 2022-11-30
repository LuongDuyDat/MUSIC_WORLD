import 'package:flutter/material.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/string.dart';
import 'package:music_world_app/util/text_style.dart';

import '../../../components/play_bar.dart';

class SongView3 extends StatefulWidget {
  final void Function() onNextClick;
  final void Function() onPrevClick;
  const SongView3({Key? key, required this.onNextClick, required this.onPrevClick,}) : super(key: key);

  @override
  _SongView3State createState() => _SongView3State();
}

class _SongView3State extends State<SongView3> {

  double _currentSlideValue = 0;

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
        _currentSlideValue = duration == null ? 0 : duration.inSeconds.toDouble();
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.1466 * screenWidth, 0.0443 * screenHeight, 0.1466 * screenWidth, 0),
              child: Column(
                children: [
                  Text(
                    lyricString,
                    style: bodyRegular1.copyWith(color: textPrimaryColor),
                  ),
                  SizedBox(height: 0.0345 * screenHeight,),
                  Text(
                    "It is a long established fact that a reader will be distracted by the readable content of a page "
                        "when looking at its layout. The point of using Lorem Ipsum is that itIt is a long established "
                        "fact that a It is a long established fact that a reader will be distis that it reader will "
                        "be distracted by the readable content of a page when looking at its layout. The point "
                        "of using Lorem Ipsum is that it",
                    textAlign: TextAlign.center,
                    style: lyric.copyWith(color: textPrimaryColor, height: 2.8),
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
        );},
    );
  }

}