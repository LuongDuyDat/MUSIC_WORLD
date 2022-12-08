import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_world_app/app/bloc/app_bloc.dart';
import 'package:music_world_app/screen/login/view/login_page.dart';
import 'package:music_world_app/screen/upload_song/view/upload_song.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/theme.dart';
import 'package:path_provider/path_provider.dart';

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
    return FutureBuilder<Directory>(
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          fileDirectory = snapshot.data!.path.substring(0, snapshot.data!.path.length - 9) + "/tmp/com.example.musicAppWorld-Inbox/";
          return BlocProvider(
            create: (_) => HomeScreenBloc(assetsAudioPlayer: assetsAudioPlayer),
            child: MaterialApp(
              home: const LoginPage(),
              theme: theme,
            ),
          );
        }
        return const Center();
      },
      future: getLibraryDirectory(),
    );
  }

}