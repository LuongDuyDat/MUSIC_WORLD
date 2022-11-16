import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_world_app/screen/search/bloc/search_bloc.dart';
import 'package:music_world_app/screen/search/bloc/search_event.dart';
import 'package:music_world_app/screen/search/view/seach_all.dart';
import 'package:music_world_app/util/string.dart';

import '../../../util/colors.dart';
import '../../../util/globals.dart';
import '../../../util/text_style.dart';

class SearchAlbum extends StatefulWidget {
  const SearchAlbum({Key? key}) : super(key: key);

  @override
  _SearchAlbumState createState() => _SearchAlbumState();
}

class _SearchAlbumState extends State<SearchAlbum> {
  late ScrollController _scrollController;

  void _scrollListener() {
    setState(() {
      if (_scrollController.position.extentAfter < 0.2 * screenHeight) {
        context.read<SearchBloc>().add(const SearchLoadMoreAlbumEvent());
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
            padding: EdgeInsets.only(left: screenWidth * 0.064, top: screenHeight * 0.01, right: screenWidth * 0.064),
            child: const SearchAlbumList(),
          ),
        ],
      ),
    );
  }
}