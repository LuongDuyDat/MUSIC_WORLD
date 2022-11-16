import 'package:flutter/material.dart';
import 'package:music_world_app/util/globals.dart';

class PlayingBar extends StatelessWidget {
  final int type;
  const PlayingBar({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        type == 0
            ? Icon(
              Icons.shuffle_outlined,
              size: screenWidth * 0.064,
              color: const Color(0xFF20242F),
            )
            : const SizedBox(width: 0, height: 0,),
        Icon(
          Icons.skip_previous_outlined,
          size: screenWidth * 0.064,
          color: const Color(0xFF20242F),
        ),
        type == 0
            ? Icon(
                Icons.play_circle_outline,
                size: screenWidth * screenWidth * 0.2,
                color: const Color(0xFF20242F),
              )
            : Icon(
                Icons.play_circle_outline,
                size: screenWidth * 0.085,
                color: const Color(0xFF20242F),
              ),
        Icon(
          Icons.skip_next_outlined,
          size: screenWidth * 0.064,
          color: const Color(0xFF20242F),
        ),
        type == 0
            ? Icon(
                Icons.loop_outlined,
                size: screenWidth * 0.064,
                color: const Color(0xFF20242F),
              )
            : const SizedBox(width: 0, height: 0,),
      ],
    );
  }

}