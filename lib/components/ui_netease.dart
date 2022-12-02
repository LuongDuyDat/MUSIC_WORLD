
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_ui/lyric_ui.dart';
import 'package:flutter_lyric/lyric_ui/ui_netease.dart';
import 'package:music_world_app/util/colors.dart';

class UiNetease extends UINetease {
  @override
  double defaultSize;
  double defaultExtSize;
  double otherMainSize;
  double bias;
  double lineGap;
  double inlineGap;
  LyricAlign lyricAlign;
  LyricBaseLine lyricBaseLine;
  bool highlight;
  HighlightDirection highlightDirection;

  UiNetease(
      {this.defaultSize = 18,
        this.defaultExtSize = 14,
        this.otherMainSize = 16,
        this.bias = 0.5,
        this.lineGap = 25,
        this.inlineGap = 25,
        this.lyricAlign = LyricAlign.CENTER,
        this.lyricBaseLine = LyricBaseLine.CENTER,
        this.highlight = true,
        this.highlightDirection = HighlightDirection.LTR});

  UiNetease.clone(UiNetease uiNetease)
      : this(
    defaultSize: uiNetease.defaultSize,
    defaultExtSize: uiNetease.defaultExtSize,
    otherMainSize: uiNetease.otherMainSize,
    bias: uiNetease.bias,
    lineGap: uiNetease.lineGap,
    inlineGap: uiNetease.inlineGap,
    lyricAlign: uiNetease.lyricAlign,
    lyricBaseLine: uiNetease.lyricBaseLine,
    highlight: uiNetease.highlight,
    highlightDirection: uiNetease.highlightDirection,
  );

  @override
  TextStyle getPlayingExtTextStyle() =>
      TextStyle(color: Colors.grey[300], fontSize: defaultExtSize);

  @override
  TextStyle getOtherExtTextStyle() => TextStyle(
    color: Colors.grey[300],
    fontSize: defaultExtSize,
  );

  @override
  TextStyle getOtherMainTextStyle() =>
      TextStyle(color: Colors.grey[200], fontSize: otherMainSize);

  @override
  TextStyle getPlayingMainTextStyle() => TextStyle(
    color: primaryColor,
    fontSize: defaultSize,
  );

  @override
  double getInlineSpace() => inlineGap;

  @override
  double getLineSpace() => lineGap;

  @override
  double getPlayingLineBias() => bias;

  @override
  LyricAlign getLyricHorizontalAlign() => lyricAlign;

  @override
  LyricBaseLine getBiasBaseLine() => lyricBaseLine;

  @override
  bool enableHighlight() => highlight;

  @override
  HighlightDirection getHighlightDirection() => highlightDirection;

  @override
  Color getLyricHightlightColor() => primaryColor;
}