import 'package:flutter/material.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/text_style.dart';

class Notifications {
  final String text;
  final double width;

  const Notifications({required this.text, required this.width});


  SnackBar build(BuildContext context) {
    return SnackBar(
      backgroundColor: Colors.transparent,
      content: Container(
        width: 50,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(203, 251, 94, 0.7),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.03733 * screenWidth, vertical: 0.00862 * screenHeight),
          child: Text(
            text,
            style: bodyRegular1.copyWith(color: const Color(0xFF20242F)),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 0.46 * screenHeight, left: 0.1 * screenWidth, right: 0.1 * screenWidth),
    );
  }
}

