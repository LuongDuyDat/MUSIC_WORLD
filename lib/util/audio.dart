import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_world_app/repositories/album_repository/models/album.dart';
import 'package:music_world_app/repositories/playlist_repository/models/playlist.dart' as my;
import 'package:path_provider/path_provider.dart';

import '../repositories/song_repository/models/song.dart';
import 'globals.dart';

Future<void> play(Song song) async {
  Map<String, dynamic> extras = {"pictures": song.picture, "song": song};
  String path = '';
  if (song.path == '') {
    final directory = await getApplicationDocumentsDirectory();
    File file = await File('${directory.path}/tmp.mp3').create();
    file = await file.writeAsBytes(song.deviceSongPath!);
    path = file.path;
  }
  try {
    assetsAudioPlayer.open(
      song.path != '' ?
      Audio(
        song.path,
        metas: Metas(
          title: song.name,
          artist: song.artist.elementAt(0).name,
          extra: extras,
          image: MetasImage.asset(song.picture),
        ),
      ) :
      Audio.file(
        path,
        metas: Metas(
          title: song.name,
          artist: song.artist.elementAt(0).name,
          extra: extras,
          image: const MetasImage.asset("assets/images/activity1.png"),
        ),
      ),
      showNotification: true,
      autoStart: true,
    );
  } catch (t) {
    debugPrint(t.toString());
  }
}

Future<void> playPlaylist(my.Playlist playlist, int? index) async{
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
    );
    await assetsAudioPlayer.playlistPlayAtIndex(index ?? 0);
  } catch (t) {
    debugPrint(t.toString());
  }
}

Future<void> playAlbum(Album album, int? index) async{
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
    );
    await assetsAudioPlayer.playlistPlayAtIndex(index ?? 0);
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