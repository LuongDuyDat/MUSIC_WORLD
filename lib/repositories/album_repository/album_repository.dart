import 'dart:math';

import 'package:hive/hive.dart';

import '../../util/globals.dart';
import '../song_repository/models/song.dart';
import 'models/album.dart';

class AlbumRepository {
  final Box<Album> albumBox;

  AlbumRepository({
    required this.albumBox,
  });

  void addAlbum(Album album) {
    albumBox.add(album);
  }

  Stream<Album> getAlbums() async* {
    var items = albumBox.values.toList();
    for (int i = 0; i < items.length; i++) {
      yield items[i];
    }
  }


  Stream<Album> getNewAlbums(int ? start, int ? length) async* {
    var items = albumBox.values.toList();
    items.sort((b, a) => a.createAt.compareTo(b.createAt));
    start ??= 0;
    length ??= 3;
    for (int i = min(start, items.length - 1); i < min(length, items.length); i++) {
      yield items[i];
    }
  }

  Stream<Album> getAlbumByKeyword(int start, int length, String keyWord) async* {
    var items = albumBox.values.where((element) {
      if (keyWord != '' && normalize(element.name).contains(normalize(keyWord)) == false) {
          return false;
      }
      return true;
    }).toList();
    for (int i = start; i < min(items.length, start + length); i++) {
      yield items[i];
    }
  }

  Stream<Album> getAlbumByArtistId(dynamic key, int start, int length, String keyWord) async* {
    var items = albumBox.values.where((element) {
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

  Stream<Song?> getSongsInAlbum(String id) async* {
    Album? album = albumBox.get(id);
    if (album == null) {
      yield null;
    }
    for (int i = 0; i < album!.song.length; i++) {
      yield album.song.elementAt(i);
    }
  }

}