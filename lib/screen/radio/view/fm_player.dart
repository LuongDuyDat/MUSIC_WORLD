import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/globals.dart';

class FmPlayer extends StatefulWidget {
  final List fm;
  final int index;

  const FmPlayer(
      {Key? key, required this.fm, required this.index})
      : super(key: key);

  @override
  State<FmPlayer> createState() => _FmState();
}

class _FmState extends State<FmPlayer> {
  late int index = widget.index;
  late List fmList = widget.fm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            Navigator.pop(context, index);
          },
        ),
        title: const Text("Radio"),
        backgroundColor: Color(0xFF0e0b1f),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${fmList[index].split("::")[1]}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(
                      fmList[index].split("::")[2],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: const ImageIcon(
                        AssetImage("assets/icons/skip_prev_icon.png"),
                        color: Color(0xFFEEEEEE),
                      ),
                      onTap: () {
                        if (index != 0) {
                          index--;
                        } else {
                          index = fmList.length - 1;
                        }
                        try {
                          assetsAudioPlayer.open(
                            Audio.liveStream(
                              fmList[index].split("::")[0],
                              metas: Metas(
                                  title: fmList[index].split("::")[1],
                                  artist: "International FM",
                                  image: MetasImage.network(fmList[index].split("::")[2],)
                              ),
                            ),
                            showNotification: true,
                            autoStart: true,
                          );
                        } catch (t) {
                          debugPrint(t.toString());
                        }
                        setState(() {

                        });
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: 73,
                        height: 73,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: textPrimaryColor,
                          ),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(36.5)),
                        ),
                        alignment: Alignment.center,
                        child: playingIcon(),
                      ),
                      onTap: () {
                        assetsAudioPlayer.playOrPause();
                      },
                    ),
                    InkWell(
                      child: const ImageIcon(
                        AssetImage("assets/icons/skip_next_icon.png"),
                        color: Color(0xFFEEEEEE),
                      ),
                      onTap: () {
                        if (index != fmList.length-1) {
                          index++;
                        } else {
                          index = 0;
                        }
                        try {
                          assetsAudioPlayer.open(
                            Audio.liveStream(
                              fmList[index].split("::")[0],
                              metas: Metas(
                                  title: fmList[index].split("::")[1],
                                  artist: "International FM",
                                  image: MetasImage.network(fmList[index].split("::")[2],)
                              ),
                            ),
                            showNotification: true,
                            autoStart: true,
                          );
                        } catch (t) {
                          debugPrint(t.toString());
                        }
                        setState(() {

                        });
                      },
                    ),
                  ],
                ),
              )
            ]),
      ),
    );
  }

  Widget playingIcon() {
      // final bool playing = assetsAudioPlayer.isPlaying.value;
    return PlayerBuilder.isPlaying(
        player: assetsAudioPlayer,
        builder: (context, isPlaying) {
          return Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 50, color: Colors.white,);
        }
    );
  }
}
