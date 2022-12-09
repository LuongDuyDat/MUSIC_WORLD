import 'dart:math';

import 'package:hive/hive.dart';
import 'package:music_world_app/repositories/album_repository/models/album.dart';
import 'package:music_world_app/repositories/artist_repository/models/artist.dart';
import 'package:music_world_app/util/globals.dart';

import '../song_repository/models/song.dart';

class ArtistRepository {
  final Box<Artist> artistBox;
  ArtistRepository({
    required this.artistBox,
  });

  void addArtist(Artist artist) {
    artistBox.add(artist);
  }

  Stream<Artist> getArtists() async* {
    var items = artistBox.values.toList();
    for (int i = 0; i < items.length; i++) {
      yield items[i];
    }
  }

  Stream<Artist> getArtistByKeyword(int start, int length, String keyWord) async* {
    var items = artistBox.values.where((element) {
      if (keyWord != '' && normalize(element.name).contains(normalize(keyWord)) == false) {
        return false;
      }
      return true;
    }).toList();
    for (int i = start; i < min(items.length, start + length); i++) {
      yield items[i];
    }
  }

  Artist? getArtistById(String id) {
    return artistBox.get(id);
  }

  Stream<Song?> getSongsByArtist(dynamic id, int start, int length, String keyWord) async* {
    Artist? artist = artistBox.get(id);
    if (artist == null) {
      yield null;
    }
    var items = artist!.song.where((element) {
      if (keyWord != '' && normalize(element.name).contains(normalize(keyWord)) == false) {
        return false;
      }
      return true;
    });
    for (int i = start; i < min(items.length, start + length); i++) {
      yield items.elementAt(i);
    }
  }

  Stream<Artist?> getFollowingArtist(dynamic id, int start, int length, String keyWord) async* {
    Artist? artist = artistBox.get(id);
    if (artist == null) {
      yield null;
    }
    var items = artist!.following.where((element) {
      if (keyWord != '' && normalize(element.name).contains(normalize(keyWord)) == false) {
        return false;
      }
      return true;
    });
    for (int i = start; i < min(items.length, start + length); i++) {
      yield items.elementAt(i);
    }
  }

  Stream<Album?> getAlbumsByArtist(dynamic id) async* {
    Artist? artist = artistBox.get(id);
    if (artist == null) {
      yield null;
    }
    for (int i = 0; i < artist!.album.length; i++) {
      yield artist.album.elementAt(i);
    }
  }

  bool followingArtist(dynamic followingId, dynamic followerId, bool isFollowing) {
    Artist? following = artistBox.get(followingId);
    Artist? follower = artistBox.get(followerId);

    if (following == null || follower == null) {
      return false;
    }

    if (isFollowing) {
      if (following.following.contains(follower) == false || follower.follower.contains(following) == false) {
        return false;
      }
      following.following.remove(follower);
      follower.follower.remove(following);
      following.save();
      follower.save();
      return true;
    }

    if (following.following.contains(follower) == true || follower.follower.contains(following) == true) {
      return false;
    }
    following.following.add(follower);
    follower.follower.add(following);
    following.save();
    follower.save();
    return true;
  }

  bool isFollowingArtist(dynamic followingId, dynamic followerId) {
    Artist? following = artistBox.get(followingId);
    Artist? follower = artistBox.get(followerId);

    if (following!.following.contains(follower)) {
      return true;
    }

    return false;
  }

  int getArtistFollowerNumber(dynamic id) {
    Artist? artist = artistBox.get(id);
    if (artist == null) {
      return -1;
    }
    return artist.follower.length;
  }

  int getArtistFollowingNumber(String id) {
    Artist? artist = artistBox.get(id);
    if (artist == null) {
      return -1;
    }
    return artist.following.length;
  }

  List<String> getRecentSearch(dynamic id) {
    Artist? artist = artistBox.get(id);
    if (artist != null) {
      int start = max(0, artist.recentSearch.length - 3);
      if (artist.recentSearch.isNotEmpty) {
        return artist.recentSearch.sublist(start).reversed.toList();
      }
    }
    return [];
  }

  void addRecentSearch(dynamic id, String content) {
    Artist? artist = artistBox.get(id);
    if (artist != null) {
      artist.recentSearch.add(content);
      artist.save();
    }
  }

}