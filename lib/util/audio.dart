import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_world_app/repositories/album_repository/models/album.dart';
import 'package:music_world_app/repositories/playlist_repository/models/playlist.dart' as my;

import '../repositories/song_repository/models/song.dart';
import 'globals.dart';

void play(Song song) {
  Map<String, dynamic> extras = {"pictures": song.picture, "song": song};
  try {
    assetsAudioPlayer.open(
      Audio(
        song.path,
        metas: Metas(
          title: song.name,
          artist: song.artist.elementAt(0).name,
          extra: extras,
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

Future<void> playPlaylist(my.Playlist playlist) async{
  try {
    await assetsAudioPlayer.open(
      Playlist(
        audios: playlist.song.map<Audio>((song) {
          Map<String, dynamic> extras = {"pictures": song.picture, 'song': song, 'playlist': playlist,};
          return Audio(
            song.path,
            metas: Metas(
              title: song.name,
              artist: song.artist.elementAt(0).name,
              extra: extras,
              image: MetasImage.asset(song.picture),
            ),
          );
        }).toList()
      ),
      loopMode: LoopMode.playlist,
      showNotification: true,
      autoStart: true,
    );
  } catch (t) {
    debugPrint(t.toString());
  }
}

Future<void> playAlbum(Album album) async{
  try {
    await assetsAudioPlayer.open(
      Playlist(
          audios: album.song.map<Audio>((song) {
            Map<String, dynamic> extras = {"pictures": song.picture, 'song': song, 'album': album,};
            return Audio(
              song.path,
              metas: Metas(
                title: song.name,
                artist: song.artist.elementAt(0).name,
                extra: extras,
                image: MetasImage.asset(song.picture),
              ),
            );
          }).toList()
      ),
      loopMode: LoopMode.playlist,
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