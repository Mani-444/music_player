import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/blocs/song/song_event.dart';
import 'package:music_player_app/blocs/song/song_state.dart';
import 'package:music_player_app/models/song_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  SongBloc() : super(SongState(songs: [])) {
    on<LoadSongsEvent>(_onLoadSongs);
    on<AddSongsEvent>(_onAddSongs);
  }

  Future<void> _onLoadSongs(
    LoadSongsEvent event,
    Emitter<SongState> emit,
  ) async {
    final sharedPreference = await SharedPreferences.getInstance();
    final jsonString = sharedPreference.getString('songs');
    if (jsonString != null) {
      final json = jsonDecode(jsonString);
      final songs = (json as List)
          .map((songJson) => SongInfoModel.fromJson(songJson))
          .toList();
      emit(state.copyWith(songs: songs));
    }
  }

  Future<void> _onAddSongs(AddSongsEvent event, Emitter<SongState> emit) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final newSongs = result.files.map((file) {
        return SongInfoModel(
          path: file.path ?? '',
          name: file.name,
        );
      }).toList();

      final updatedSongs = [...state.songs, ...newSongs];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('songs', jsonEncode(updatedSongs));

      emit(state.copyWith(songs: updatedSongs));
    }
  }
}
