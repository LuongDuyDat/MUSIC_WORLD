import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'fm_player.dart';
import '../../../util/string.dart';
import 'package:music_world_app/util/text_style.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';

class Fm extends StatefulWidget {
  Fm({Key? key}) : super(key: key);

  @override
  State<Fm> createState() => _FmState();
}

class _FmState extends State<Fm> {
  List fm = [];
  var items = [];
  int id = 0;

  @override
  void initState() {
    super.initState();
    getFm();
  }

  @override
  void dispose() {
    super.dispose();
    // player.dispose();
  }

  getFm() async {
    try {
      var response = await http.get(Uri.parse(
          "https://gist.githubusercontent.com/sirimathxd/d27a26895c36a04b027b8e92aac10369/raw/fm.txt"));
      if (response.statusCode == 200) {
        setState(() {
          fm = response.body.split("\n");
          items.addAll(fm);
        });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(errorString1),
                content: Text(errorDetail1),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(okString)
                  )
                ],
              );
            }
        );
      }
    } on SocketException {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(errorString2),
            content: Text(errorDetail2),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(okString),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fm.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: ListView.builder(
          itemBuilder: (context, index) {
            return InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20,),
                  index < 9 ? Text('0' + (index+1).toString(), style: bodyRoboto2.copyWith(color: textPrimaryColor),)
                      : Text((index+1).toString(), style: bodyRoboto2.copyWith(color: textPrimaryColor),),
                  const SizedBox(width: 20,),
                  Flexible(
                    child:  ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.00446),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3.0),
                          child: Image.network(items[index].split("::")[2], width: 32, height: 32, fit: BoxFit.cover,),
                        ),
                      ),
                      title: Text(
                        items[index].split("::")[1],
                        style: bodyRoboto2.copyWith(color: textPrimaryColor),
                      ),
                      subtitle: Text(
                        "International FM",
                        style: bodyRegular3.copyWith(color: const Color(0xFF817A7A)),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_horiz),
                        color: textPrimaryColor,
                        onPressed: (){},
                      ),
                    ),
                  )
                ],
              ),
              onTap: () {
                try {
                  assetsAudioPlayer.open(
                    Audio.liveStream(
                      items[index].split("::")[0],
                      metas: Metas(
                        title: items[index].split("::")[1],
                        artist: "International FM",
                        image: MetasImage.network(items[index].split("::")[2],)
                      ),
                    ),
                    showNotification: true,
                    autoStart: true,
                  );
                } catch (t) {
                  debugPrint(t.toString());
                }
                setState(() {
                  id = fm.indexOf(items[index]);
                });
                _navigate(context);
              },
            );
          },
          itemCount: items.length,
        ),
      );
    }
  }

  Future<void> _navigate(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FmPlayer(fm: fm, index: id)),
    );
    setState(() {
      id = result;
    });
  }
}

