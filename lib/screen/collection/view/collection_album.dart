import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:music_world_app/components/search_bar.dart';
import 'package:music_world_app/components/song_tile.dart';
import 'package:music_world_app/repositories/album_repository/album_repository.dart';
import 'package:music_world_app/repositories/album_repository/models/album.dart';
import 'package:music_world_app/screen/collection/bloc/album_bloc/album_bloc.dart';
import 'package:music_world_app/screen/collection/bloc/album_bloc/album_event.dart';
import 'package:music_world_app/screen/collection/bloc/album_bloc/album_state.dart';
import 'package:music_world_app/screen/explore/view/topic.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/string.dart';

import '../../../util/globals.dart';
import '../../../util/navigate.dart';
import '../../../util/text_style.dart';

class CollectionAlbum extends StatelessWidget {
  final dynamic type;
  const CollectionAlbum({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Album> albumBox = Hive.box<Album>('album');
    return BlocProvider(
      create: (_) => AlbumBloc(albumRepository: AlbumRepository(albumBox: albumBox)),
      child: CollectionAlbumView(type: type,),
    );
  }
}

class CollectionAlbumView extends StatelessWidget {
  final dynamic type;
  const CollectionAlbumView({Key? key, required this.type,}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    void onChangeSearchWord(String keyWord) {
      if (type != "new") {
        context.read<AlbumBloc>().add(AlbumSearchWordChange(id: type == "me" ? account.key : type,
            keyWord: keyWord));
      }
    }
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          padding: EdgeInsets.only(left: 0.0365 * screenWidth),
          icon: const Icon(Icons.arrow_back),
          iconSize: 24,
          onPressed: () {
            Navigate.popPage(context);
          },
        ),
        title: Text(
          albumString,
          style: title5.copyWith(color: textPrimaryColor),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.064 * screenWidth, 0, 0.064 * screenWidth, 0),
            child: Column(
              children: [
                SizedBox(height: 0.0246 * screenHeight,),
                SearchBar(width: 0.872 * screenWidth, onTextChange: onChangeSearchWord,),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0.064 * screenWidth, 0.015 * screenHeight, 0.05 * screenWidth, 0),
              child: SizedBox(
                height: screenHeight * 0.78,
                // Todo: new album
                child: type == "new" ? ListView(
                  shrinkWrap: true,
                  children: [
                    CollectionListTile(
                      leadingAsset: "assets/images/Album1.png",
                      songName: "No 9",
                      artist: "Girl Generation",
                      number: 1,
                      onTap: () {
                        Navigate.pushPage(context, const Topic(type: "Album"));
                      },
                    ),
                    CollectionListTile(
                      leadingAsset: "assets/images/Album2.png",
                      songName: "Help XX",
                      artist: "Suji Wong",
                      number: 2,
                      onTap: () {
                        Navigate.pushPage(context, const Topic(type: "Album"));
                      },
                    ),
                    CollectionListTile(
                      leadingAsset: "assets/images/Album3.png",
                      songName: "IZZYI",
                      artist: "Mercia",
                      number: 3,
                      onTap: () {
                        Navigate.pushPage(context, const Topic(type: "Album"));
                      },
                    ),
                    CollectionListTile(
                      leadingAsset: "assets/images/Album4.png",
                      songName: "Turn Off",
                      artist: "Mino",
                      number: 4,
                      onTap: () {
                        Navigate.pushPage(context, const Topic(type: "Album"));
                      },
                    ),
                    CollectionListTile(
                      leadingAsset: "assets/images/Album1.png",
                      songName: "Where are you now ?",
                      artist: "Suji Wong",
                      number: 5,
                      onTap: () {
                        Navigate.pushPage(context, const Topic(type: "Album"));
                      },
                    ),
                    CollectionListTile(
                      leadingAsset: "assets/images/Album2.png",
                      songName: "W",
                      artist: "DBSK",
                      number: 6,
                      onTap: () {
                        Navigate.pushPage(context, const Topic(type: "Album"));
                      },
                    ),
                    CollectionListTile(
                      leadingAsset: "assets/images/Album3.png",
                      songName: "Studio 09",
                      artist: "Suji Wong",
                      number: 7,
                      onTap: () {
                        Navigate.pushPage(context, const Topic(type: "Album"));
                      },
                    ),
                    CollectionListTile(
                      leadingAsset: "assets/images/Album4.png",
                      songName: "That ZZ",
                      artist: "Mino",
                      number: 8,
                      onTap: () {
                        Navigate.pushPage(context, const Topic(type: "Album"));
                      },
                    ),
                  ],
                ) : Albums(type: type),
              )
          )
        ],
      ),
    );
  }
}

class Albums extends StatefulWidget {
  final dynamic type;

  const Albums({Key? key, required this.type,}) : super(key: key);

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  late ScrollController _scrollController;

  void _scrollListener() {
    setState(() {
      if (_scrollController.position.extentAfter < 0.27 * screenHeight) {
        context.read<AlbumBloc>().add(AlbumLoadMoreAlbum(widget.type == "me" ? account.key : widget.type));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, state) {
        switch (state.albumStatus) {
          case AlbumStatus.initial:
            context.read<AlbumBloc>().add(AlbumSubscriptionRequest(widget.type == "me" ? account.key : widget.type));
            return const Center();
          case AlbumStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case AlbumStatus.success:
            return ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                return CollectionListTile(
                  leadingAsset: state.albums.elementAt(index).picture,
                  songName: state.albums.elementAt(index).name,
                  artist: state.albums.elementAt(index).artist.elementAt(0).name,
                  number: index + 1,
                  onTap: () {
                    Navigate.pushPage(context, Topic(type: "Album", album: state.albums.elementAt(index),));
                  },
                );
              },
              itemCount: state.albums.length,
            );
          case AlbumStatus.failure:
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
      }
    );
  }
  
}