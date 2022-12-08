import 'package:bloc/bloc.dart';
import 'package:music_world_app/repositories/song_repository/song_repository.dart';
import 'package:music_world_app/screen/upload_song/bloc/upload_song_event.dart';
import 'package:music_world_app/screen/upload_song/bloc/upload_song_state.dart';
import 'package:music_world_app/util/globals.dart';

class UploadSongBloc extends Bloc<UploadSongEvent, UploadSongState> {
  UploadSongBloc({
    required SongRepository songRepository,
  }) : _songRepository = songRepository,
      super(const UploadSongState()) {
    on<UploadSongTitleChange>(_onTitleChange);
    on<UploadSongIntroductionChange>(_onIntroductionChange);
    on<UploadSongImageChange>(_onImageChange);
    on<UploadSongPathChange>(_onSongPathChange);
    on<UploadSongLyricChange>(_onLyricChange);
    on<UploadSongSubmit>(_onSubmit);
  }

  final SongRepository _songRepository;

  void _onTitleChange(
      UploadSongTitleChange event,
      Emitter<UploadSongState> emit,
      ) {
    emit(state.copyWith(
      title: () => event.title,
    ));
  }

  void _onIntroductionChange(
      UploadSongIntroductionChange event,
      Emitter<UploadSongState> emit,
      ) {
    emit(state.copyWith(
      introduction: () => event.introduction,
    ));
  }

  void _onImageChange(
      UploadSongImageChange event,
      Emitter<UploadSongState> emit,
      ) {
    emit(state.copyWith(
      pickedImage: () => event.file,
    ));
  }

  void _onSongPathChange(
      UploadSongPathChange event,
      Emitter<UploadSongState> emit,
      ) {
    emit(state.copyWith(
      songPath: () => event.songPath,
    ));
  }

  void _onLyricChange(
      UploadSongLyricChange event,
      Emitter<UploadSongState> emit,
      ) {
    emit(state.copyWith(
      lyricPath: () => event.lyricPath,
    ));
  }

  Future<void> _onSubmit (
      UploadSongSubmit event,
      Emitter<UploadSongState> emit,
      ) async{
      emit(state.copyWith(
        uploadSongStatus: () => UploadSongStatus.loading,
      ));
      await _songRepository.createSong(
        state.title,
        account,
        '',
        state.introduction,
        '',
        '',
        state.pickedImage,
        state.songPath,
        state.lyricPath,
      );
      emit(state.copyWith(
        uploadSongStatus: () => UploadSongStatus.success,
      ));
  }
}