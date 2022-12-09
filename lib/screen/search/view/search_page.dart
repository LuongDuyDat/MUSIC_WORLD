import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_world_app/repositories/album_repository/album_repository.dart';
import 'package:music_world_app/repositories/artist_repository/artist_repository.dart';
import 'package:music_world_app/repositories/artist_repository/models/artist.dart';
import 'package:music_world_app/repositories/playlist_repository/models/playlist.dart';
import 'package:music_world_app/repositories/playlist_repository/playlist_repository.dart';
import 'package:music_world_app/repositories/song_repository/song_repository.dart';
import 'package:music_world_app/screen/search/bloc/search_bloc.dart';
import 'package:music_world_app/screen/search/bloc/search_state.dart';
import 'package:music_world_app/screen/search/view/seach_all.dart';
import 'package:music_world_app/screen/search/view/search_album.dart';
import 'package:music_world_app/screen/search/view/search_artist.dart';
import 'package:music_world_app/screen/search/view/search_playlist.dart';
import 'package:music_world_app/screen/search/view/search_song.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/navigate.dart';
import 'package:music_world_app/util/string.dart';
import 'package:music_world_app/util/text_style.dart';

import '../../../components/button.dart';
import '../../../repositories/album_repository/models/album.dart';
import '../../../repositories/song_repository/models/song.dart';
import '../bloc/search_event.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Album> albumBox = Hive.box<Album>('album');
    Box<Playlist> playlistBox = Hive.box<Playlist>('playlist');
    Box<Song> songBox = Hive.box<Song>('song');
    Box<Artist> artistBox = Hive.box<Artist>('artist');
    return BlocProvider(
      create: (_) => SearchBloc(
        albumRepository: AlbumRepository(albumBox: albumBox),
        playlistRepository: PlaylistRepository(playlistBox: playlistBox),
        songRepository: SongRepository(songBox: songBox),
        artistRepository: ArtistRepository(artistBox: artistBox),
      ),
      child: const SearchPageView(),
    );
  }

}

class SearchPageView extends StatefulWidget {
  const SearchPageView({Key? key}) : super(key: key);

  @override
  _SearchPageViewState createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  final TextEditingController _controller = TextEditingController();

  void changeText(String text) {
    setState(() {
      _controller.text = text;
    });
    context.read<SearchBloc>().add(SearchWordChange(keyWord: text));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          centerTitle: false,
          leadingWidth: screenWidth * 0.064,
          titleSpacing: 0,
          leading: SizedBox(width: screenWidth * 0.064,),
          title: Container(
              width: 0.752 * screenWidth,
              height: screenHeight * 0.044335,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Color(0xFF292D39),
              ),
              child: Center(
                child: RawKeyboardListener(
                  child: TextField(
                    controller: _controller,
                    style: bodyRegular1.copyWith(color: neutralColor2),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.white, size: 20,),
                      hintText: searchString,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintStyle: bodyRegular1.copyWith(color: neutralColor2),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.text = "";
                          });
                          context.read<SearchBloc>().add(const SearchWordChange(keyWord: ''));
                        },
                        icon: Icon(Icons.cancel_outlined, size: 12, color: neutralColor2),
                      ),
                    ),
                    autofocus: false,
                    cursorColor: primaryColor,
                    onChanged: (text) {
                      context.read<SearchBloc>().add(SearchWordChange(keyWord: text));
                    },
                  ),
                  onKey: (event) {
                    if (event.data.logicalKey.keyId == LogicalKeyboardKey.enter.keyId) {

                    }
                  },
                  focusNode: FocusNode(),
                ),
              )
          ),
          actions: [
            Center(
              child: Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.064,),
                  child: InkWell(
                    child: Text(
                      cancelString,
                      style: subHeadline2.copyWith(color: primaryColor),
                    ),
                    onTap: () {
                      Navigate.popPage(context);
                    },
                  )
              ),
            )
          ],
          bottom: const BottomTabBar(),
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          buildWhen: (previous, current) {
            if (previous.searchWord != current.searchWord) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            switch (state.searchWord) {
              case '':
                return Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.064, right: screenWidth * 0.064, top: screenHeight * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        historyString,
                        style: title5.copyWith(
                          color: textPrimaryColor,
                        ),
                      ),
                      Container(
                        height: screenHeight * 0.0345,
                        margin: EdgeInsets.only(top: screenHeight * 0.0172),
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              width: screenWidth * 0.2267,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                              ),
                              child: Button2(
                                text: "Fall out boy",
                                onPressed: () => changeText("Fall out boy"),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.032,),
                            Container(
                              width: screenWidth * 0.2267,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                              ),
                              child: Button2(
                                text: "Good girl",
                                onPressed: () => changeText("Good girl"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.049,),
                      Text(
                        topSearchString,
                        style: title5.copyWith(
                          color: textPrimaryColor,
                        ),
                      ),
                      Container(
                        height: screenHeight * 0.0345,
                        margin: EdgeInsets.only(top: screenHeight * 0.0172),
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.2267,
                              child: Button(
                                text: "Girl",
                                radius: 0,
                                minimumSize: screenHeight * 0.0345,
                                type: bodyRegular3,
                                onPressed: () => changeText("Girl"),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.032,),
                            SizedBox(
                              width: screenWidth * 0.2267,
                              child: Button(
                                text: "Imagine",
                                radius: 0,
                                minimumSize: screenHeight * 0.0345,
                                type: bodyRegular3,
                                onPressed: () => changeText("Imagine"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              default:
                return const TabBarView(
                    children: [
                      SearchAll(),
                      SearchArtist(),
                      SearchAlbum(),
                      SearchPlaylist(),
                      SearchSong(),
                    ]
                );
            }
          },
        ),
      ),
    );
  }
}


class Button2 extends StatelessWidget {
  final String text;
  final Function? onPressed;

  const Button2({Key? key, required this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: const Color(0xFF20242F),
        backgroundColor: Colors.transparent,
        textStyle: bodyMedium1.copyWith(color: textPrimaryColor),
      ),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      child: Center(
        child: Text(text, overflow: TextOverflow.ellipsis, style: bodyRegular3.copyWith(color: primaryColor),),
      ),
    );
  }

}

class BottomTabBar extends StatelessWidget with PreferredSizeWidget {
  const BottomTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) {
        if (previous.searchWord != current.searchWord) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        switch (state.searchWord) {
          case '':
            return PreferredSize(preferredSize: const Size(0.0, 0.0),child: Container(),);
          default:
            return TabBar(
              tabs: [
                Tab(
                  text: allString,
                ),
                Tab(
                  text: artistString,
                ),
                Tab(
                  text: albumString,
                ),
                Tab(
                  text: playlistString,
                ),
                Tab(
                  text: songString,
                ),
              ],
              labelColor: textPrimaryColor,
              unselectedLabelColor: neutralColor2,
              indicatorColor: textPrimaryColor,
              labelStyle: title5,
              unselectedLabelStyle: bodyRoboto2,
            );
        }
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(screenHeight / 15);

}
