import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_world_app/util/globals.dart';

import '../app/bloc/app_bloc.dart';
import '../app/bloc/app_event.dart';

class PlayingBar extends StatelessWidget {
  final int type;
  final void Function() onNextClick;
  final void Function() onPrevClick;
  const PlayingBar({Key? key, required this.type, required this.onNextClick, required this.onPrevClick,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: assetsAudioPlayer.isPlaying,
        builder: (context, asyncSnapshot) {
          bool isPlaying = asyncSnapshot.data ?? false;
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
              InkWell(
                child: Icon(
                  Icons.skip_previous_outlined,
                  size: screenWidth * 0.064,
                  color: const Color(0xFF20242F),
                ),
                onTap: onPrevClick,
              ),
              type == 0
                  ? Icon(
                Icons.play_circle_outline,
                size: screenWidth * screenWidth * 0.2,
                color: const Color(0xFF20242F),
              )
                  : InkWell(
                child: Icon(
                  isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                  size: screenWidth * 0.085,
                  color: const Color(0xFF20242F),
                ),
                onTap: () {
                  assetsAudioPlayer.playOrPause();
                  },
              ),
              InkWell(
                child: Icon(
                  Icons.skip_next_outlined,
                  size: screenWidth * 0.064,
                  color: const Color(0xFF20242F),
                ),
                onTap: onNextClick,
              ),
              type == 0
                  ? Icon(
                Icons.loop_outlined,
                size: screenWidth * 0.064,
                color: const Color(0xFF20242F),
              )
                  : InkWell(
                child: Icon(
                  Icons.cancel_outlined,
                  size: screenWidth * 0.064,
                  color: const Color(0xFF20242F),
                ),
                onTap: () {
                  BlocProvider.of<HomeScreenBloc>(context).add(const HomeChangeIsPlaying(isPlaying: false));
                },
              ),
            ],
          );
        }
    );
  }

}