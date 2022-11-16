import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_world_app/screen/singer/view/singer_info.dart';
import 'package:music_world_app/screen/song/bloc/song_bloc.dart';
import 'package:music_world_app/screen/song/bloc/song_event.dart';
import 'package:music_world_app/screen/song/bloc/song_state.dart';
import 'package:music_world_app/screen/song/view/song_page.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/navigate.dart';
import 'package:music_world_app/util/string.dart';
import 'package:music_world_app/util/text_style.dart';

import '../../../components/song_tile.dart';
import '../../../repositories/song_repository/models/song.dart';

class SongView1 extends StatelessWidget {
  final Song song;
  const SongView1({Key? key, required this.song,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0.064 * screenWidth, 0.24 * screenHeight, 0.064 * screenWidth, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 0.1 * screenHeight,
                ),
                child: Text(
                  song.name,
                  style: title2.copyWith(color: textPrimaryColor),
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
              SizedBox(height: 0.0345 * screenHeight,),
              RichText(
                text: TextSpan(
                  text: song.introduction,
                  style: lyric.copyWith(color: textPrimaryColor,),
                  children: [
                    TextSpan(
                        text: ' ',
                        style: lyric,
                    ),
                    TextSpan(
                      text: showMoreString,
                      style: lyric.copyWith(color: neutralColor2, decoration: TextDecoration.underline,),
                    ),
                  ]
                ),
              ),
              SizedBox(height: 0.044 * screenHeight),
              Divider(
                color: neutralColor2,
              ),
              SizedBox(height: 0.044 * screenHeight),
              Text(
                suggestionsString,
                style: headlineBold1.copyWith(color: textPrimaryColor),
              ),
              SizedBox(
                height: 0.24 * screenHeight,
                child: SuggestionSong(song: song,),
              ),
            ],
          ),
        ),
      ],
    );
  }

}

class SuggestionSong extends StatelessWidget {
  final Song song;

  const SuggestionSong({Key? key, required this.song,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        switch(state.songSuggestionStatus) {
          case SongStatus.initial:
            context.read<SongBloc>().add(SuggestionSongSubscriptionRequest(song));
            return const Center();
          case SongStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case SongStatus.success:
            return ListView.builder(
              itemBuilder: (context, index) {
                return CollectionListTile(
                  leadingAsset: state.songSuggestion.elementAt(index).picture,
                  songName: state.songSuggestion.elementAt(index).name,
                  artist: state.songSuggestion.elementAt(index).artist.elementAt(0).name,
                  number: index + 1,
                  onTap: () {
                    Navigate.pushPage(context, SongPage(song: state.songSuggestion.elementAt(index)));
                  },
                );
              },
              itemCount: state.songSuggestion.length,
            );
          case SongStatus.failure:
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