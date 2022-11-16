import 'dart:math';

import 'package:hive/hive.dart';
import 'package:music_world_app/repositories/playlist_repository/models/playlist.dart';
import 'package:music_world_app/util/globals.dart';

import '../song_repository/models/song.dart';

class PlaylistRepository {
  final Box<Playlist> playlistBox;

  PlaylistRepository({
    required this.playlistBox,
  });

  void addPlaylist(Playlist playlist) {
    playlistBox.add(playlist);
  }

  Stream<Playlist> getPlaylists() async* {
    var items = playlistBox.values.toList();
    for (int i = 0; i < items.length; i++) {
      yield items[i];
    }
  }

  Stream<Playlist> getPlaylistsByKeyword(int start, int length, String keyWord) async* {
    var items = playlistBox.values.where((element) {
      if (keyWord != '' && normalize(element.name).contains(normalize(keyWord)) == false) {
        return false;
      }
      return true;
    }).toList();
    for (int i = start; i < min(items.length, start + length); i++) {
      yield items[i];
    }
  }

  Stream<Playlist> getPlaylistsByArtistId(dynamic key, int start, int length, String keyWord) async* {
    var items = playlistBox.values.where((element) {
      if (element.artist.keys.contains(key)) {
        if (keyWord != '' && normalize(element.name).contains(normalize(keyWord)) == false) {
          return false;
        }
        return true;
      }
      return false;
    }).toList();
    for (int i = start; i < min(items.length, start + length); i++) {
      yield items[i];
    }
  }

  Stream<Song?> getSongsInPlaylist(String id) async* {
    Playlist? playlist = playlistBox.get(id);
    if (playlist == null) {
      yield null;
    }
    for (int i = 0; i < playlist!.song.length; i++) {
      yield playlist.song.elementAt(i);
    }
  }

}