import 'package:flutter/material.dart';
import 'package:music_world_app/screen/account/view/edit_profile.dart';
import 'package:music_world_app/screen/collection/view/collection_album.dart';
import 'package:music_world_app/screen/collection/view/collection_artist.dart';
import 'package:music_world_app/screen/collection/view/collection_playlist.dart';
import 'package:music_world_app/screen/collection/view/collection_song.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/navigate.dart';

import '../../../components/button.dart';
import '../../../components/show_more_tile.dart';
import '../../../util/colors.dart';
import '../../../util/string.dart';
import '../../../util/text_style.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.064 * screenWidth, 0.015 * screenHeight, 0.064 * screenWidth, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      account.picture,
                      width: 0.2133 * screenWidth,
                      height: 0.2133 * screenWidth,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 0.0933 * screenWidth,),
                    SizedBox(
                      width: 0.5654 * screenWidth,
                      height: 0.2133 * screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    account.playlist.length.toString(),
                                    style: bodyRegular1.copyWith(color: textPrimaryColor),
                                  ),
                                  Text(
                                    playlistString,
                                    style: bodyRegular1.copyWith(color: textPrimaryColor),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    account.follower.length > 1000 ? (account.follower.length ~/ 1000).toString() + " K" :
                                    account.follower.length.toString(),
                                    style: bodyRegular1.copyWith(color: textPrimaryColor),
                                  ),
                                  Text(
                                    followerString,
                                    style: bodyRegular1.copyWith(color: textPrimaryColor),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    account.following.length > 1000 ? (account.following.length ~/ 1000).toString() + " K" :
                                    account.following.length.toString(),
                                    style: bodyRegular1.copyWith(color: textPrimaryColor),
                                  ),
                                  Text(
                                    followingString,
                                    style: bodyRegular1.copyWith(color: textPrimaryColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 0.208 * screenWidth,
                            height: screenHeight * 0.0345,
                            child: Button(
                              text: editString,
                              radius: 0,
                              minimumSize: screenHeight * 0.0345,
                              type: bodyRoboto2,
                              onPressed: () {
                                Navigate.pushPage(context, const EditProfile());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.0394 * screenHeight,),
                Text(
                  libraryString,
                  style: title5.copyWith(color: textPrimaryColor),
                ),
                SizedBox(height: 0.01 * screenHeight,),
                ShowMoreListTile(
                  title: myPlaylistString,
                  icon: "assets/icons/playlist_icon.png",
                  trailing: "navigate_next",
                  onTap: () {
                    Navigate.pushPage(context, const CollectionPlaylist(type: "me",));
                  },
                ),
                Divider(color: neutralColor3, thickness: 1.5,),
                ShowMoreListTile(
                  title: albumString,
                  icon: "assets/icons/album_icon.png",
                  trailing: "navigate_next",
                  onTap: () {
                    Navigate.pushPage(context, const CollectionAlbum(type: "me",));
                  },
                ),
                Divider(color: neutralColor3, thickness: 1.5,),
                ShowMoreListTile(
                  title: artistString,
                  icon: "assets/icons/artist_icon.png",
                  trailing: "navigate_next",
                  onTap: () {
                    Navigate.pushPage(context, const CollectionArtist(type: "me",));
                  },
                ),
                Divider(color: neutralColor3, thickness: 1.5,),
                ShowMoreListTile(
                  title: downloadString,
                  icon: "assets/icons/download_icon.png",
                  trailing: "navigate_next",
                  onTap: () {
                    Navigate.pushPage(context, const CollectionSong(type: "me",));
                  },
                ),
                SizedBox(height: 0.01 * screenHeight,),
                Text(
                  recentActivityString,
                  style: title5.copyWith(color: textPrimaryColor),
                ),
                SizedBox(height: 0.0246 * screenHeight,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/activity1.png",
                      width: 0.2133 * screenWidth,
                      height: 0.2133 * screenWidth,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      "assets/images/activity2.png",
                      width: 0.2133 * screenWidth,
                      height: 0.2133 * screenWidth,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      "assets/images/activity3.png",
                      width: 0.2133 * screenWidth,
                      height: 0.2133 * screenWidth,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                SizedBox(height: 0.0246 * screenHeight,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/activity4.png",
                      width: 0.2133 * screenWidth,
                      height: 0.2133 * screenWidth,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      "assets/images/activity5.png",
                      width: 0.2133 * screenWidth,
                      height: 0.2133 * screenWidth,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      "assets/images/activity6.png",
                      width: 0.2133 * screenWidth,
                      height: 0.2133 * screenWidth,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}