import 'dart:math';

import 'package:hive/hive.dart';
import 'package:music_world_app/repositories/artist_repository/models/artist.dart';
import 'package:music_world_app/repositories/song_repository/models/song.dart';

import '../../util/globals.dart';

class SongRepository {
  final Box<Song> songBox;

  SongRepository({
    required this.songBox,
  });

  void addSong(Song song) {
    songBox.add(song);
  }

  Stream<Song> getSongs() async* {
    var items = songBox.values.toList();
    for (int i = 0; i < items.length; i++) {
      yield items[i];
    }
  }

  Stream<Song> getPopularSongs(int start, int end) async* {
    var items = songBox.values.toList();
    items.sort((b, a) => a.listenNumber.compareTo(b.listenNumber));
    for (int i = max(start, 0); i < min(end, items.length); i++) {
      yield items[i];
    }
  }

  Stream<Song> getRecentSongs(int limit) async* {
    var items = songBox.values.toList();
    items.sort((b, a) => a.createAt.compareTo(b.createAt));
    for (int i = 0; i < min(items.length, limit); i++) {
      yield items[i];
    }
  }

  Stream<Song> loadMoreRecentSongs(int index, int more) async* {
    var items = songBox.values.toList();
    items.sort((b, a) => a.createAt.compareTo(b.createAt));
    for (int i = index; i < min(items.length, index + more - 1); i++) {
      yield items[i];
    }
  }

  Stream<Song> getSuggestionSong(Song song, int limit) async* {
    var items = songBox.values.toList();
    items.remove(song);
    items.sort((b, a) {
      if (b.artist.elementAt(0).name == song.artist.elementAt(0).name
          && a.artist.elementAt(0).name != song.artist.elementAt(0).name) return 1;
      if (a.artist.elementAt(0).name == song.artist.elementAt(0).name
          && b.artist.elementAt(0).name != song.artist.elementAt(0).name) return 1;
      return 0;
    });
    for (int i = 0; i < 3; i++) {
      yield(items[i]);
    }
  }

  Stream<Song> getPopularSongsByArtistId(Artist artist) async* {
    var items = songBox.values.where((element) {
      if (element.artist.keys.contains(artist.key)) {
        return true;
      }
      return false;
    }).toList();
    for (int i = 0; i < items.length; i++) {
      yield items[i];
    }
  }

  Stream<Song> getSongByKeyword(int start, int length, String keyWord) async* {
    var items = songBox.values.where((element) {
      if (keyWord != '' && normalize(element.name).contains(normalize(keyWord)) == false) {
        return false;
      }
      return true;
    }).toList();
    for (int i = start; i < min(items.length, start + length); i++) {
      yield items[i];
    }
  }

  Song? getArtistById(String id) {
    return songBox.get(id);
  }
}