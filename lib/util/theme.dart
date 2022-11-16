import 'package:flutter/material.dart';
import 'package:music_world_app/util/colors.dart';

final theme = ThemeData(
  primaryColor: primaryColor,
  primaryColorDark: neutralColor3,
  primaryColorLight: textPrimaryColor,
  scaffoldBackgroundColor: backgroundColor,
  secondaryHeaderColor: neutralColor1,
  inputDecorationTheme: InputDecorationTheme(
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: neutralColor2),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: neutralColor1),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: neutralColor2),
    ),
  )
);