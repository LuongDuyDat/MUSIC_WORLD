import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_world_app/screen/search/bloc/search_event.dart';
import 'package:music_world_app/screen/search/view/seach_all.dart';
import 'package:music_world_app/util/string.dart';

import '../../../util/colors.dart';
import '../../../util/globals.dart';
import '../../../util/text_style.dart';
import '../bloc/search_bloc.dart';

class SearchSong extends StatefulWidget {
  const SearchSong({Key? key}) : super(key: key);

  @override
  _SearchSongState createState() => _SearchSongState();
}

class _SearchSongState extends State<SearchSong> {
  late ScrollController _scrollController;

  void _scrollListener() {
    setState(() {
      if (_scrollController.position.extentAfter < 0.2 * screenHeight) {
        print(_scrollController.position.extentAfter);
        context.read<SearchBloc>().add(const SearchLoadMoreSongEvent());
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
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.064, screenHeight * 0.0394, screenWidth * 0.064, 0),
            child: Text(
              topSearchString,
              style: subHeadline1.copyWith(color: textPrimaryColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.064, top: screenHeight * 0.01, right: 0.064 * screenWidth,),
            child: const SearchSongList(),
          ),
        ],
      ),
    );
  }
}