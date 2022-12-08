import 'package:flutter/material.dart';
import 'package:music_world_app/screen/song/view/song_page.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/navigate.dart';
import 'package:music_world_app/util/text_style.dart';

class CollectionListTile extends StatelessWidget {
  final int? number;
  final String leadingAsset;
  final String songName;
  final String? artist;
  final double large;
  final Function() onTap;
  final bool? isPlaying;
  const CollectionListTile({
    Key? key,
    this.number,
    required this.leadingAsset,
    required this.songName,
    this.artist,
    this.large = 32,
    required this.onTap,
    this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isPlaying == true ? Icon(Icons.equalizer, color: primaryColor, size: 15,)
          : (number != null ? (number! < 10 ? Text('0' + number.toString(), style: bodyRoboto2.copyWith(color: textPrimaryColor),)
              : Text(number.toString(), style: bodyRoboto2.copyWith(color: textPrimaryColor),))
              : const SizedBox(width: 0, height: 0,)),
          number != null ? const SizedBox(width: 20,) : const SizedBox(width: 0,),
          Flexible(
            child:  ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.00446),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3.0),
                  child: Image.asset(leadingAsset, width: large, height: large, fit: BoxFit.cover,),
                ),
              ),
              title: Text(
                songName,
                style: bodyRoboto2.copyWith(color: isPlaying != true ? textPrimaryColor : primaryColor),
              ),
              subtitle: artist != null ? Text(
                artist!,
                style: bodyRegular3.copyWith(color: isPlaying != true ? const Color(0xFF817A7A) : primaryColor),
              ) : null,
              trailing: IconButton(
                icon: const Icon(Icons.more_horiz),
                color: isPlaying != true ? textPrimaryColor : primaryColor,
                onPressed: (){},
              ),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }

}