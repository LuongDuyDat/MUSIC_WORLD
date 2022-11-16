import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_world_app/app.dart';
import 'package:music_world_app/bloc_observer.dart';
import 'package:music_world_app/repositories/album_repository/models/album.dart';
import 'package:music_world_app/repositories/artist_repository/models/artist.dart';
import 'package:music_world_app/repositories/playlist_repository/models/playlist.dart';
import 'package:music_world_app/repositories/song_repository/models/song.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  await Hive.initFlutter();
  Hive.registerAdapter(ArtistAdapter());
  Hive.registerAdapter(AlbumAdapter());
  Hive.registerAdapter(SongAdapter());
  Hive.registerAdapter(PlaylistAdapter());
  await Hive.openBox<Song>('song');
  await Hive.openBox<Artist>('artist');
  await Hive.openBox<Playlist>('playlist');
  await Hive.openBox<Album>('album');
  runApp(const App());
}