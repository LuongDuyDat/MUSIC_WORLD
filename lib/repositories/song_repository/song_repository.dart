import 'dart:math';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
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

  void addFavorite(Artist artist, Song song) async{
    artist.favorites ??= HiveList(Hive.box<Song>('song'));
    artist.favorites!.add(song);
    await artist.save();
  }

  void removeFavorite(Artist artist, Song song) async{
    artist.favorites!.remove(song);
    await artist.save();
  }

  bool checkFavorite(Artist artist, Song song) {
    if (artist.favorites == null) {
      return false;
    }
    return artist.favorites!.contains(song);
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
    print(items.length);
    items.sort((a, b) => a.createAt.compareTo(b.createAt));
    for (int i = 0; i < min(items.length, limit); i++) {
      yield items[i];
    }
  }

  Stream<Song> loadMoreRecentSongs(int index, int more) async* {
    var items = songBox.values.toList();
    items.sort((a, b) => a.createAt.compareTo(b.createAt));
    for (int i = index; i < min(items.length, index + more); i++) {
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

  Future<void> createSong(String name, Artist artist, String path, String introduction, String picture, String lyricPath, XFile? image, Uint8List? localSong, Uint8List? localLyric) async{
    var artistBox = Hive.box<Artist>('artist');
    Uint8List? i;
    if (image != null) {
      i = await image.readAsBytes();
    }
    Song temp = Song(
        name: name,
        artist: HiveList(artistBox),
        path: path,
        introduction: introduction,
        picture: picture,
        listenNumber: 0,
        createAt: DateTime.now(),
        lyricPath: lyricPath,
        image: i,
        deviceSongPath: localSong,
        deviceLyricPath: localLyric,
    );
    temp.artist.add(artist);
    await songBox.add(temp);
    artist.song.add(temp);
    artist.save();
  }

  Future<void> deleteSong(dynamic key) async {
    var songBox = Hive.box<Song>('song');

    await songBox.delete(key);
  }

  Song? getArtistById(String id) {
    return songBox.get(id);
  }
}