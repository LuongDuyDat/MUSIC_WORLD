import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';
import 'fm_player.dart';
import '../../../util/string.dart';

class Fm extends StatefulWidget {
  final AudioPlayer player = AudioPlayer();
  Fm({Key? key}) : super(key: key);

  @override
  State<Fm> createState() => _FmState();
}

class _FmState extends State<Fm> {
  late AudioPlayer player = widget.player;
  List fm = [];
  var items = [];
  int indexx = 0;

  @override
  void initState() {
    super.initState();
    getFm();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
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
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Column(
          children: <Widget>[
            Expanded (
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Platform.isAndroid ? 2 : 6,
                ),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 8,
                        height: MediaQuery.of(context).size.height / 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: NetworkImage(
                              items[index].split("::")[2],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          player.play(UrlSource(items[index].split("::")[0]));
                          indexx = fm.indexOf(items[index]);
                          player.resume();
                          player.state = PlayerState.playing;
                        });
                        // _navigate(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomSheet: Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color(0xFF454545),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              GestureDetector (
                onTap: () {
                  // player.play(UrlSource(items[index].split("::")[0]));
                  // setState(() {
                  //   indexx = fm.indexOf(items[index]);
                  //   player.state == PlayerState.playing;
                  // });
                  _navigate(context);
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage(
                        fm[indexx].split("::")[2],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 9,
                height: 30,
                child: Marquee(
                  text: fm[indexx].split("::")[1],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 20.0,
                  velocity: 100.0,
                  pauseAfterRound: const Duration(seconds: 1),
                  startPadding: 10.0,
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: const Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                ),
              ),
              const Spacer(),
              Card(
                child: IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () {
                    if (indexx != 0) {
                      indexx--;
                      player.play(UrlSource(fm[indexx].split("::")[0]));
                    } else {
                      indexx = fm.length - 1;
                      player.play(UrlSource(fm[indexx].split("::")[0]));
                    }
                    setState(() {
                      player.state = PlayerState.playing;
                    });
                  },
                ),
              ),
              Card(
                child: IconButton(
                  icon:player.state != PlayerState.playing
                      ? const Icon(Icons.play_arrow)
                      : const Icon(Icons.pause),
                  onPressed: ()  {
                    if (player.state == PlayerState.paused) {
                      player.resume();
                      setState(() {
                        player.state = PlayerState.playing;
                      });
                    } else if (player.state == PlayerState.playing) {
                      player.pause();
                      setState(() {
                        player.state = PlayerState.paused;
                      });
                    } else {
                      player.play(UrlSource(fm[indexx].split("::")[0]));
                      setState(() {
                        player.state = PlayerState.playing;
                      });
                    }
                  },
                ),
              ),
              Card(
                child: IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {
                    if (indexx != fm.length - 1) {
                      indexx++;
                      player.play(UrlSource(fm[indexx].split("::")[0]));
                    } else {
                      indexx = 0;
                      player.play(UrlSource(fm[indexx].split("::")[0]));
                    }
                    setState(() {
                      player.state = PlayerState.playing;
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _navigate(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FmPlayer(fm: fm, index: indexx, player: player)),
    );
    setState(() {
      indexx = result;
    });
  }
}

