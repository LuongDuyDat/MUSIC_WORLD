import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

enum UploadSongStatus {initial, loading, success}


class UploadSongState extends Equatable {
  const UploadSongState({
    this.title = '',
    this.introduction = '',
    this.pickedImage,
    this.songPath,
    this.lyricPath,
    this.songFile,
    this.lyricFile,
    this.uploadSongStatus = UploadSongStatus.initial,
  });

  final String title;
  final String introduction;
  final XFile? pickedImage;
  final String? songPath;
  final Uint8List? songFile;
  final String? lyricPath;
  final Uint8List? lyricFile;
  final UploadSongStatus uploadSongStatus;

  UploadSongState copyWith({
    String Function()? title,
    String Function()? introduction,
    XFile Function()? pickedImage,
    String Function()? songPath,
    Uint8List Function()? songFile,
    String Function()? lyricPath,
    Uint8List Function()? lyricFile,
    UploadSongStatus Function()? uploadSongStatus,
  }) {
    return UploadSongState(
      title: title != null ? title() : this.title,
      introduction: introduction != null ? introduction() : this.introduction,
      pickedImage: pickedImage != null ? pickedImage() : this.pickedImage,
      songPath: songPath != null ? songPath() : this.songPath,
      songFile: songFile != null ? songFile() : this.songFile,
      lyricPath: lyricPath != null ? lyricPath() : this.lyricPath,
      lyricFile: lyricFile != null ? lyricFile() : this.lyricFile,
      uploadSongStatus: uploadSongStatus != null ? uploadSongStatus() : this.uploadSongStatus,
    );

  }

  @override
  List<Object?> get props => [
    title,
    introduction,
    pickedImage,
    songPath,
    lyricPath,
    uploadSongStatus,
  ];
}