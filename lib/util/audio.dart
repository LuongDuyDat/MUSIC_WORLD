import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';

import '../repositories/song_repository/models/song.dart';
import 'globals.dart';

void play(Song song) {
  try {
    assetsAudioPlayer.open(
      Audio(
        song.path,
        metas: Metas(
          title: song.name,
          artist: song.artist.elementAt(0).name,
          image: MetasImage.asset(song.picture),
        ),
      ),
      showNotification: true,
      autoStart: true,
    );
  } catch (t) {
    debugPrint(t.toString());
  }
}

void pause() {
  assetsAudioPlayer.pause();
}

void seek(int seconds) {
  assetsAudioPlayer.seek(Duration(seconds: seconds));
}

void seekBy(int seconds) {
  assetsAudioPlayer.seekBy(Duration(seconds: seconds));
}