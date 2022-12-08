import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class UploadSongEvent extends Equatable {
  const UploadSongEvent();

  @override
  List<Object?> get props => [];
}

class UploadSongTitleChange extends UploadSongEvent {
  const UploadSongTitleChange({
    required this.title,
  });

  final String title;

  @override
  List<Object?> get props => [title];
}

class UploadSongIntroductionChange extends UploadSongEvent {
  const UploadSongIntroductionChange({
    required this.introduction,
  });

  final String introduction;

  @override
  List<Object?> get props => [introduction];
}

class UploadSongImageChange extends UploadSongEvent {
  const UploadSongImageChange({
    required this.file,
  });

  final XFile file;

  @override
  List<Object?> get props => [file];
}

class UploadSongPathChange extends UploadSongEvent {
  const UploadSongPathChange({
    required this.songPath,
    required this.songFile,
  });

  final String songPath;
  final Uint8List songFile;

  @override
  List<Object?> get props => [songPath, songFile];
}

class UploadSongLyricChange extends UploadSongEvent {
  const UploadSongLyricChange({
    required this.lyricPath,
    required this.lyricFile,
  });

  final String lyricPath;
  final Uint8List lyricFile;

  @override
  List<Object?> get props => [lyricPath, lyricFile];
}

class UploadSongSubmit extends UploadSongEvent {
  const UploadSongSubmit();
}