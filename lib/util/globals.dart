library globals;

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hive/hive.dart';
import 'package:music_world_app/repositories/artist_repository/models/artist.dart';

import '../repositories/song_repository/models/song.dart';

String lang = 'en';
double screenWidth = 0;
double screenHeight = 0;
bool isPlayingSong = true;

Box<Artist> a = Hive.box<Artist>('artist');
Artist account = a.values.toList().elementAt(a.values.toList().length - 1);

String normalize(String s) {
  /// normalize a string for text-matching
  s = s.toLowerCase();
  for (int i = 0; i < s.length; i++) {
    if (s[i] == 'á' || s[i] == 'à' || s[i] == 'ả' || s[i] == 'ạ' || s[i] == 'ã') {
      s = s.replaceRange(i, i+1, 'a');
    }
    if (s[i] == 'ă' || s[i] == 'ằ' || s[i] == 'ẳ' || s[i] == 'ặ' || s[i] == 'ắ' || s[i] == 'ẵ') {
      s = s.replaceRange(i, i+1, 'a');
    }
    if (s[i] == 'â' || s[i] == 'ầ' || s[i] == 'ẩ' || s[i] == 'ậ' || s[i] == 'ấ' || s[i] == 'ẫ') {
      s = s.replaceRange(i, i+1, 'a');
    }
    if (s[i] == 'đ') {
      s = s.replaceRange(i, i+1, 'd');
    }
    if (s[i] == 'é' || s[i] == 'è' || s[i] == 'ẻ' || s[i] == 'ẹ' || s[i] == 'ẽ') {
      s = s.replaceRange(i, i+1, 'e');
    }
    if (s[i] == 'ê' || s[i] == 'ề' || s[i] == 'ể' || s[i] == 'ệ' || s[i] == 'ế' || s[i] == 'ễ') {
      s = s.replaceRange(i, i+1, 'e');
    }
    if (s[i] == 'í' || s[i] == 'ì' || s[i] == 'ỉ' || s[i] == 'ị' || s[i] == 'ĩ') {
      s = s.replaceRange(i, i+1, 'i');
    }
    if (s[i] == 'ó' || s[i] == 'ò' || s[i] == 'ỏ' || s[i] == 'ọ' || s[i] == 'õ') {
      s = s.replaceRange(i, i+1, 'o');
    }
    if (s[i] == 'ô' || s[i] == 'ồ' || s[i] == 'ổ' || s[i] == 'ộ' || s[i] == 'ố' || s[i] == 'ỗ') {
      s = s.replaceRange(i, i+1, 'o');
    }
    if (s[i] == 'ơ' || s[i] == 'ờ' || s[i] == 'ở' || s[i] == 'ợ' || s[i] == 'ớ' || s[i] == 'ỡ') {
      s = s.replaceRange(i, i+1, 'o');
    }
    if (s[i] == 'ú' || s[i] == 'ù' || s[i] == 'ủ' || s[i] == 'ụ' || s[i] == 'ũ') {
      s = s.replaceRange(i, i+1, 'u');
    }
    if (s[i] == 'ứ' || s[i] == 'ừ' || s[i] == 'ử' || s[i] == 'ự' || s[i] == 'ư' || s[i] == 'ữ') {
      s = s.replaceRange(i, i+1, 'u');
    }
  }
  return s;
}

final assetsAudioPlayer = AssetsAudioPlayer();
int shuffleSingle = 0;
var prevSong = List<int>.filled(10000, 0, growable: false);
