import 'package:flutter/material.dart';

import '../util/colors.dart';
import '../util/globals.dart';
import '../util/string.dart';
import '../util/text_style.dart';

class SearchBar extends StatefulWidget {
  final double width;
  final Function(String)? onTextChange;
  const SearchBar({Key? key, required this.width, this.onTextChange,}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();

}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(onTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(onTextChange);
    super.dispose();
  }

  void onTextChange() {
    widget.onTextChange!(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: screenHeight * 0.044335,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Color(0xFF292D39),
        ),
        child: Center(
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
              ),
              autofocus: false,
              cursorColor: primaryColor,
          ),
        )
    );
  }

}