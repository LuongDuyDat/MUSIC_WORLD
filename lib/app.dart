import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_world_app/screen/app_bloc.dart';
import 'package:music_world_app/screen/login/view/login_page.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/theme.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeScreenBloc(assetsAudioPlayer: assetsAudioPlayer),
      child: MaterialApp(
        home: const LoginPage(),
        theme: theme,
      ),
    );
  }

}