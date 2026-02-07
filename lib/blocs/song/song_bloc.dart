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
    on<DeleteSongEvent>(_onDeleteSong);
  }

  Future<void> _onLoadSongs(
    LoadSongsEvent event,
    Emitter<SongState> emit,
  ) async {
    final sharedPreference = await SharedPreferences.getInstance();
    final jsonString = sharedPreference.getString('songs');
    if (jsonString != null) {
      final json = jsonDecode(jsonString);
      final songs =
          (json as List)
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
      final existingSongs = List<SongInfoModel>.from(state.songs);

      // Use name as unique identifier
      final existingNames = state.songs.map((s) => _normalize(s.name)).toSet();

      final List<SongInfoModel> filteredNewSongs = [];
      for (final file in result.files) {
        final path = file.path;
        if (path == null || path.isEmpty) continue;

        if (!existingNames.contains(_normalize(file.name))) {
          filteredNewSongs.add(SongInfoModel(path: path, name: file.name));
          existingNames.add(path); // prevent duplicates in same selection
        }
      }

      // If no new songs, do nothing
      if (filteredNewSongs.isEmpty) return;

      final updatedSongs = [...existingSongs, ...filteredNewSongs];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('songs', jsonEncode(updatedSongs));

      emit(state.copyWith(songs: updatedSongs));
    }
  }

  String _normalize(String name) {
    return name.toLowerCase().trim();
  }

  Future<void> _onDeleteSong(
    DeleteSongEvent event,
    Emitter<SongState> emit,
  ) async {
    final updatedSongs =
        state.songs.where((song) => song.path != event.song.path).toList();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('songs', jsonEncode(updatedSongs));

    emit(state.copyWith(songs: updatedSongs));
  }
}
