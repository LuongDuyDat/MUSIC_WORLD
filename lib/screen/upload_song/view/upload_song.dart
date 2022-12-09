
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_world_app/repositories/song_repository/models/song.dart';
import 'package:music_world_app/repositories/song_repository/song_repository.dart';
import 'package:music_world_app/screen/upload_song/bloc/upload_song_bloc.dart';
import 'package:music_world_app/screen/upload_song/bloc/upload_song_event.dart';
import 'package:music_world_app/screen/upload_song/bloc/upload_song_state.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/string.dart';

import '../../../components/notifications.dart';
import '../../../util/globals.dart';
import '../../../util/navigate.dart';
import '../../../util/text_style.dart';

class UploadSong extends StatelessWidget {
  const UploadSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Song> songBox = Hive.box<Song>('song');
    return BlocProvider(
      create: (_) => UploadSongBloc(songRepository: SongRepository(songBox: songBox),),
      child: const UploadSongView(),
    );
  }

}

class UploadSongView extends StatefulWidget {
  const UploadSongView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UploadSongViewState();

}

class _UploadSongViewState extends State<UploadSongView> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadSongBloc, UploadSongState>(
      builder: (context, state) {
        switch (state.uploadSongStatus) {
          case UploadSongStatus.success:
            return FutureBuilder<Future>(
              builder: (context, snapshot) {
                return const Center();
              },
              future: Future.microtask(() => Navigate.pushPageReplacement(context, const UploadSong())),
            );
          default:
            return Scaffold(
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
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 0.0365 * screenWidth),
                    child: IconButton(
                      onPressed: () {
                        if (state.title == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const Notifications(
                                width: 200,
                                text: 'Please enter the title',
                              ).build(context));
                          return;
                        }
                        if (state.introduction == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const Notifications(
                                width: 200,
                                text: 'Please enter the introduction',
                              ).build(context));
                          return;
                        }
                        if (state.pickedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const Notifications(
                                width: 200,
                                text: 'Please pick the image',
                              ).build(context));
                          return;
                        }
                        if (state.songPath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const Notifications(
                                width: 200,
                                text: 'Please upload the mp3 file',
                              ).build(context));
                          return;
                        }
                        if (state.lyricPath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const Notifications(
                                width: 200,
                                text: 'Please upload the lrc file',
                              ).build(context));
                          return;
                        }
                        context.read<UploadSongBloc>().add(const UploadSongSubmit());
                      },
                      icon: Icon(Icons.cloud_upload, color: textPrimaryColor,),
                      iconSize: 24,
                    ),
                  ),
                ],
                title: Text(
                  uploadSongString,
                  style: title5.copyWith(color: textPrimaryColor),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.064),
                      child: Column(
                        children: [
                          SizedBox(height: 0.0446 * screenHeight,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                child: Container(
                                  width: min(0.167 * screenHeight, 0.362 * screenWidth),
                                  height: min(0.167 * screenHeight, 0.362 * screenWidth),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(131, 101, 115, 1),
                                        Color.fromRGBO(113, 144, 154, 1),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: state.pickedImage == null ? Center(
                                    child: ImageIcon(
                                      const AssetImage("assets/icons/camera_plus_icon.png"),
                                      color: textPrimaryColor,
                                      size: 60,
                                    ),
                                  ) : Image.file(
                                    File(state.pickedImage!.path),
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                onTap: () async{
                                  final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                                  if (pickedImage != null) {
                                    context.read<UploadSongBloc>().add(UploadSongImageChange(file: pickedImage));
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 0.05 * screenHeight,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  UploadButton(text: chooseSongString),
                                  SizedBox(height: 0.01 * screenHeight,),
                                  SizedBox(
                                    width: 0.362 * screenWidth,
                                    height: 0.05 * screenHeight,
                                    child: Text(
                                      state.songPath != null ? state.songPath!.substring(state.songPath!.contains("/tmp") ? state.songPath!.indexOf("/tmp") + 37 : 0)
                                          : '',
                                      style: lyric.copyWith(
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  UploadButton(text: chooseLyricString),
                                  SizedBox(height: 0.01 * screenHeight,),
                                  SizedBox(
                                    width: 0.362 * screenWidth,
                                    height: 0.05 * screenHeight,
                                    child: Text(
                                      state.lyricPath != null ? state.lyricPath!.substring(state.lyricPath!.contains("/tmp") ? state.lyricPath!.indexOf("/tmp") + 37 : 0)
                                          : '',
                                      style: lyric.copyWith(
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.064),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 0.0335 * screenHeight,),
                          Text(
                            titleString,
                            style: subHeadline1.copyWith(color: textPrimaryColor),
                          ),
                          SizedBox(height: 0.017 * screenHeight,),
                          TextField(
                            cursorColor: primaryColor,
                            style: bodyRegular1.copyWith(color: textPrimaryColor),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textPrimaryColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                            onChanged: (value) {
                              context.read<UploadSongBloc>().add(UploadSongTitleChange(title: value));
                            },
                          ),
                          SizedBox(height: 0.0335 * screenHeight,),
                          Text(
                            introductionString,
                            style: subHeadline1.copyWith(color: textPrimaryColor),
                          ),
                          SizedBox(height: 0.017 * screenHeight,),
                          TextFormField(
                            maxLines: 4,
                            cursorColor: primaryColor,
                            style: bodyRegular1.copyWith(color: textPrimaryColor),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: textPrimaryColor, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(color: primaryColor, width: 1),
                              ),
                            ),
                            onChanged: (value) {
                              context.read<UploadSongBloc>().add(UploadSongIntroductionChange(introduction: value));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}

class UploadButton extends StatelessWidget {
  const UploadButton({Key? key, required this.text,}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
        if (pickedFile != null) {
          Uint8List path = await File(pickedFile.files.single.path!).readAsBytes();
          int length = pickedFile.files.single.path!.length;
          String check = pickedFile.files.single.path!.substring(length - 4);
          if (text == chooseSongString) {
            if (check == ".mp3") {
              context.read<UploadSongBloc>().add(UploadSongPathChange(songPath: pickedFile.files.single.path!, songFile: path,));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const Notifications(
                    width: 200,
                    text: 'File is not .mp3 format',
                  ).build(context));
            }
          } else {
            if (check == '.lrc') {
              context.read<UploadSongBloc>().add(UploadSongLyricChange(lyricPath: pickedFile.files.single.path!, lyricFile: path));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const Notifications(
                    width: 200,
                    text: 'File is not .lrc format',
                  ).build(context));
            }
          }
        }
      },
      child: Container(
        width: 0.362 * screenWidth,
        height: 0.0335 * screenHeight,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: primaryColor,
        ),
        child: Center(
          child: Text(
            text,
            style: lyric.copyWith(
              color: const Color(0xFF20242F),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

}