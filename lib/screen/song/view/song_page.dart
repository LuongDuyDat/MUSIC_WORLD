import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_world_app/repositories/song_repository/song_repository.dart';
import 'package:music_world_app/screen/song/bloc/song_bloc.dart';
import 'package:music_world_app/screen/song/view/song_view1.dart';
import 'package:music_world_app/screen/song/view/song_view2.dart';
import 'package:music_world_app/screen/song/view/song_view3.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';

import '../../../repositories/song_repository/models/song.dart';
import '../../../util/navigate.dart';
import '../../app_bloc.dart';
import '../../app_event.dart';

class SongPage extends StatefulWidget {
  final int selectedIndex;
  const SongPage({Key? key, this.selectedIndex = 0,}) : super(key: key);

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  void onNextClick() {
    BlocProvider.of<HomeScreenBloc>(context).add(const HomeNextSongClick());
  }

  void onPrevClick() {
    BlocProvider.of<HomeScreenBloc>(context).add(const HomePrevSongClick());
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screen = [
      const SongView1(),
      SongView2(onNextClick: onNextClick, onPrevClick: onPrevClick,),
      SongView3(onNextClick: onNextClick, onPrevClick: onPrevClick,),
    ];
    Box<Song> songBox = Hive.box<Song>('song');
    double distance = 0;
    return Stack(
      children: [
        selectedIndex != 1 ?
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/song_background.png"),
                  fit: BoxFit.cover,
                )
            ),
          ) :
          const SizedBox(width: 0, height: 0,),
        GestureDetector(
          onPanUpdate: (details) {
            distance = details.delta.dx;
          },
          onPanEnd: (DragEndDetails details) {
            if (distance > 2 && selectedIndex > 0) {
              setState(() {
                selectedIndex--;
              });
            } else if (distance < -2 && selectedIndex < 2) {
              setState(() {
                selectedIndex++;
              });
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: selectedIndex == 1 ? backgroundColor : Colors.transparent,
            appBar: AppBar(
              backgroundColor: selectedIndex == 1 ? backgroundColor : Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down, size: 35,),
                onPressed: () {
                  Navigate.popPage(context);
                },
              ),
            ),
            body: Column(
              children: [
                SizedBox(height: 0.06 * screenHeight,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 3,
                      decoration: BoxDecoration(
                        color: selectedIndex != 0 ? const Color(0xFF71737B) : textPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 4.77,),
                    Container(
                      width: 20,
                      height: 3,
                      decoration: BoxDecoration(
                        color: selectedIndex != 1 ? const Color(0xFF71737B) : textPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 4.77,),
                    Container(
                      width: 20,
                      height: 3,
                      decoration: BoxDecoration(
                        color: selectedIndex != 2 ? const Color(0xFF71737B) : textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                BlocProvider(
                  create: (_) => SongBloc(songRepository: SongRepository(songBox: songBox)),
                  child: screen[selectedIndex],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}