import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';

class PlayingBar extends StatefulWidget {
  final int type;
  const PlayingBar({Key? key, required this.type,}) : super(key: key);

  @override
  _PlayingBarState createState() => _PlayingBarState();
}

class _PlayingBarState extends State<PlayingBar> {
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
                const ImageIcon(
                  AssetImage("assets/icons/shuffle_icon.png"),
                  color: Color(0xFFEEEEEE),
                ),
                const ImageIcon(
                  AssetImage("assets/icons/skip_prev_icon.png"),
                  color: Color(0xFFEEEEEE),
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
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 50,
                      color: const Color(0xFFEEEEEE),
                    ),
                  ),
                  onTap: () {
                    assetsAudioPlayer.playOrPause();
                  },
                ),
                const ImageIcon(
                  AssetImage("assets/icons/skip_next_icon.png"),
                  color: Color(0xFFEEEEEE),
                ),
                InkWell(
                  child: ImageIcon(
                    const AssetImage("assets/icons/loop_icon.png"),
                    color: loop == LoopMode.none ? const Color(0xFFEEEEEE) : primaryColor,
                  ),
                  onTap: () {
                    //print(1);
                    if (loop == LoopMode.none) {
                      assetsAudioPlayer.setLoopMode(LoopMode.single);
                    } else {
                      assetsAudioPlayer.toggleLoop();
                    }
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

}