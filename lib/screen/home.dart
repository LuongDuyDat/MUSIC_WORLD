import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_world_app/components/playing_bar.dart';
import 'package:music_world_app/screen/account/view/account.dart';
import 'package:music_world_app/screen/account/view/setting.dart';
import 'package:music_world_app/screen/explore/view/explore_page.dart';
import 'package:music_world_app/screen/app_bloc.dart';
import 'package:music_world_app/screen/app_state.dart';
import 'package:music_world_app/screen/search/view/search_page.dart';
import 'package:music_world_app/screen/radio/view/radio_page.dart';
import 'package:music_world_app/screen/song/view/song_page.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/navigate.dart';
import 'package:music_world_app/util/string.dart';
import 'package:music_world_app/util/text_style.dart';

import '../util/globals.dart';
import 'home/view/home_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  List<Color> itemColor = [
    primaryColor,
    neutralColor2,
    neutralColor2,
    neutralColor2,
  ];

  // static const TextStyle optionStyle =
  // TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static final screen = [ //TODO: constance
    const Home(),
    const ExplorePage(),
    Fm(),
    const AccountPage(),
  ];

  void _onItemTapped(int _index) {
    setState(() {
      itemColor[index] = neutralColor2;
      itemColor[_index] = primaryColor;
      index = _index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final item = [
      ImageIcon(
        const AssetImage("assets/icons/home_icon.png"),
        color: itemColor[0],
      ),
      ImageIcon(
        const AssetImage("assets/icons/pin_icon.png"),
        color: itemColor[1],
      ),
      ImageIcon(
        const AssetImage("assets/icons/radio_icon.png"),
        color: itemColor[2],
      ),
      ImageIcon(
        const AssetImage("assets/icons/account_icon.png"),
        color: itemColor[3],
      ),
    ];
    final List<String> title = [
      homeString,
      exploreString,
      radioString,
      accountString,
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leadingWidth: 0,
        toolbarHeight: 100,
        title: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.025),
          child: Text(
            title[index],
            style: title1.copyWith(
              color: textPrimaryColor,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.064),
            child: index == 0 || index == 1
                ? IconButton(
              onPressed: () {
                Navigate.pushPage(context, const SearchPage());
              },
              icon: const Icon(Icons.search),
            )
                : index == 3
                ? IconButton(
              onPressed: () {
                Navigate.pushPage(context, const SettingPage());
              },
              icon: const Icon(Icons.settings),
            )
                : const SizedBox(width: 0, height: 0,),
          ),
        ],
      ),

      body: Center(
          child: Stack(
            children: [
              screen[index],
              Align(
                alignment: Alignment.bottomCenter,
                child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
                  builder: (BuildContext context, state) {
                    switch (state.isPlaying) {
                      case true:
                        return InkWell(
                          child: Container(
                              height: 0.079 * screenHeight,
                              decoration: BoxDecoration(
                                color: primaryColor,
                              ),
                              child: Center(
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.064),
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage(assetsAudioPlayer.getCurrentAudioextra["pictures"]),
                                  ),
                                  title: Text(
                                    assetsAudioPlayer.getCurrentAudioTitle,
                                    style: bodyRoboto2.copyWith(color: neutralColor3),
                                  ),
                                  trailing: Container(
                                    alignment: Alignment.centerRight,
                                    width: screenWidth * 0.3413,
                                    child: const PlayingBar(type: 1),
                                  ),
                                ),
                              )
                          ),
                          onTap: () {
                            Navigate.pushPage(context, SongPage(song: playingSong, selectedIndex: 1, isOpen: true,));
                          },
                        );
                      default:
                        return const SizedBox(width: 0, height: 0,);
                    }
                  },

                ),
              ),
            ],
          )
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: item[0],
            label: homeString,
            backgroundColor: backgroundColor,
          ),
          BottomNavigationBarItem(
            icon: item[1],
            label: exploreString,
            backgroundColor: backgroundColor,
          ),
          BottomNavigationBarItem(
            icon: item[2],
            label: radioString,
            backgroundColor: backgroundColor,
          ),
          BottomNavigationBarItem(
            icon: item[3],
            label: accountString,
            backgroundColor: backgroundColor,
          ),
        ],
        currentIndex: index,
        selectedItemColor: primaryColor,
        unselectedItemColor: neutralColor2,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }

}