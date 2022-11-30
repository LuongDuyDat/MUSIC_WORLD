import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_world_app/components/song_tile.dart';
import 'package:music_world_app/screen/explore/view/topic.dart';
import 'package:music_world_app/screen/search/bloc/search_bloc.dart';
import 'package:music_world_app/screen/search/bloc/search_state.dart';
import 'package:music_world_app/screen/singer/view/singer_info.dart';
import 'package:music_world_app/screen/song/view/song_page.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/navigate.dart';
import 'package:music_world_app/util/string.dart';
import 'package:music_world_app/util/text_style.dart';

import '../../../app/bloc/app_bloc.dart';
import '../../../app/bloc/app_event.dart';

class SearchAll extends StatelessWidget {
  const SearchAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.064, screenHeight * 0.0394, screenWidth * 0.064, 0),
              child: Text(
                artistString,
                style: subHeadline1.copyWith(color: textPrimaryColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.064, top: screenHeight * 0.01, right: screenWidth * 0.064),
              child: const SearchArtistList(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.064, 0, screenWidth * 0.064, 0),
              child: Text(
                albumString,
                style: subHeadline1.copyWith(color: textPrimaryColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.064, top: screenHeight * 0.01, right: screenWidth * 0.064,),
              child: const SearchAlbumList(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.064, 0, screenWidth * 0.064, 0),
              child: Text(
                playlistString,
                style: subHeadline1.copyWith(color: textPrimaryColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.064, top: screenHeight * 0.01, right: screenWidth * 0.064,),
              child: const SearchPlaylistList(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.064, 0, screenWidth * 0.064, 0),
              child: Text(
                songString,
                style: subHeadline1.copyWith(color: textPrimaryColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.064, top: screenHeight * 0.01, right: screenWidth * 0.064,),
              child: const SearchSongList(),
            ),
          ],
      ),
    );
  }

}

class SearchAlbumList extends StatelessWidget {
  const SearchAlbumList({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) {
        if (previous.albums != current.albums || previous.albumStatus != current.albumStatus) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        switch (state.albumStatus) {
          case SearchStatus.initial:
            return const Center();
          case SearchStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case SearchStatus.success:
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(indent: screenWidth * 0.175, color: neutralColor2, height: 15,);
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return CollectionListTile(
                  leadingAsset: state.albums.elementAt(index).picture,
                  songName: state.albums.elementAt(index).name,
                  artist: state.albums.elementAt(index).artist.elementAt(0).name,
                  large: 40,
                  onTap: () {
                    Navigate.pushPage(context, Topic(type: "Album", album: state.albums.elementAt(index),));
                  },
                );
              },
              itemCount: state.albums.length,
            );
          case SearchStatus.failure:
            return Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight / 15),
              child: Center(
                child: Text(
                  somethingWrong,
                  style: title5.copyWith(color: textPrimaryColor),
                ),
              ),
            );
        }
      },
    );
  }
}

class SearchPlaylistList extends StatelessWidget {
  const SearchPlaylistList({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) {
        if (previous.playlists != current.playlists || previous.playlistStatus != current.playlistStatus) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        switch (state.playlistStatus) {
          case SearchStatus.initial:
            return const Center();
          case SearchStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case SearchStatus.success:
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(indent: screenWidth * 0.175, color: neutralColor2, height: 15,);
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return CollectionListTile(
                  leadingAsset: state.playlists.elementAt(index).picture,
                  songName: state.playlists.elementAt(index).name,
                  artist: state.playlists.elementAt(index).artist.elementAt(0).name,
                  large: 40,
                  onTap: () {
                    Navigate.pushPage(context, Topic(type: "Playlist", playlist: state.playlists.elementAt(index),));
                  },
                );
              },
              itemCount: state.playlists.length,
            );
          case SearchStatus.failure:
            return Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight / 15),
              child: Center(
                child: Text(
                  somethingWrong,
                  style: title5.copyWith(color: textPrimaryColor),
                ),
              ),
            );
        }
      },
    );
  }
}

class SearchSongList extends StatelessWidget {
  const SearchSongList({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) {
        if (previous.songs != current.songs || previous.songStatus != current.songStatus) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        switch (state.songStatus) {
          case SearchStatus.initial:
            return const Center();
          case SearchStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case SearchStatus.success:
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(indent: screenWidth * 0.175, color: neutralColor2, height: 15,);
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return CollectionListTile(
                  leadingAsset: state.songs.elementAt(index).picture,
                  songName: state.songs.elementAt(index).name,
                  artist: state.songs.elementAt(index).artist.elementAt(0).name,
                  large: 40,
                  onTap: () {
                    BlocProvider.of<HomeScreenBloc>(context).add(HomeOnClickSong(song: state.songs.elementAt(index),));
                    Navigate.pushPage(context, const SongPage());
                  },
                );
              },
              itemCount: state.songs.length,
            );
          case SearchStatus.failure:
            return Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight / 15),
              child: Center(
                child: Text(
                  somethingWrong,
                  style: title5.copyWith(color: textPrimaryColor),
                ),
              ),
            );
        }
      },
    );
  }
}

class SearchArtistList extends StatelessWidget {
  const SearchArtistList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) {
        if (previous.artists != current.artists || previous.artistStatus != current.artistStatus) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        switch (state.artistStatus) {
          case SearchStatus.initial:
            return const Center();
          case SearchStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case SearchStatus.success:
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(indent: screenWidth * 0.175, color: neutralColor2, height: 15,);
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return CollectionListTile(
                  leadingAsset: state.artists.elementAt(index).picture,
                  songName: state.artists.elementAt(index).name,
                  large: 40,
                  onTap: () {
                    Navigate.pushPage(context, SingerInfo(artist: state.artists.elementAt(index)));
                  },
                );
              },
              itemCount: state.artists.length,
            );
          case SearchStatus.failure:
            return Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight / 15),
              child: Center(
                child: Text(
                  somethingWrong,
                  style: title5.copyWith(color: textPrimaryColor),
                ),
              ),
            );
        }
      },
    );
  }
}