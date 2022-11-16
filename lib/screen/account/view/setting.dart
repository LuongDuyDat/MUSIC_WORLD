import 'package:flutter/material.dart';
import 'package:music_world_app/components/show_more_tile.dart';
import 'package:music_world_app/screen/login/view/login_page.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/navigate.dart';
import 'package:music_world_app/util/text_style.dart';

import '../../../util/string.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          settingString,
          style: title5.copyWith(color: textPrimaryColor),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.064 * screenWidth, 0.02 * screenHeight, 0.064 * screenWidth, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShowMoreListTile(title: notificationString, icon: "assets/icons/notification_icon.png", trailing: "toggle_on",),
                Divider(color: neutralColor3, thickness: 1.5,),
                ShowMoreListTile(title: displayLanguageString, icon: "assets/icons/language_icon.png", trailing: "navigate_next",),
                Divider(color: neutralColor3, thickness: 1.5,),
                ShowMoreListTile(title: versionString + " 1.0", icon: "assets/icons/version_icon.png", trailing: "navigate_next",),
                Container(
                  margin: EdgeInsets.only(top: 0.48 * screenHeight,),
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor,)
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.fromHeight(0.05665 * screenHeight),
                      primary: primaryColor,
                      backgroundColor: backgroundColor,
                      textStyle: bodyMedium1,
                    ),
                    onPressed: () {
                      Navigate.pushPage(context, const LoginPage());
                    },
                    child: Text(signOutString),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}