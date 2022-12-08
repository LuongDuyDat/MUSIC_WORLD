import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_world_app/app/bloc/app_bloc.dart';
import 'package:music_world_app/screen/login/view/login_page.dart';
import 'package:music_world_app/screen/upload_song/view/upload_song.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/theme.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppState();

}

class _AppState extends State<App> {

  @override
  void dispose() {
    super.dispose();
    assetsAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeScreenBloc(assetsAudioPlayer: assetsAudioPlayer),
      child: MaterialApp(
        home: const UploadSong(),
        theme: theme,
      ),
    );
  }

}