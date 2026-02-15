// playlist_bloc.dart
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/blocs/playlists/playlist_event.dart';
import 'package:music_player_app/blocs/playlists/playlist_state.dart';
import 'package:music_player_app/models/playlist_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc() : super(PlaylistState(playlists: [])) {
    on<LoadPlaylistsEvent>(_onLoad);
    on<CreatePlaylistEvent>(_onCreate);
    on<AddSongToPlaylistEvent>(_onAddSong);
    on<RemoveSongFromPlaylistEvent>(_onRemoveSong);
    on<RemoveSongFromAllPlaylistsEvent>(_onRemoveSongFromAllPlaylists);
  }

  Future<void> _onLoad(
    LoadPlaylistsEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('playlists');

    if (data != null) {
      final decoded = jsonDecode(data) as List;
      final playlists = decoded.map((e) => PlaylistModel.fromJson(e)).toList();
      emit(state.copyWith(playlists: playlists));
    }
  }

  Future<void> _save(List<PlaylistModel> playlists) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'playlists',
      jsonEncode(playlists.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> _onCreate(
    CreatePlaylistEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    final exists = state.playlists.any(
      (p) => p.name.toLowerCase() == event.name.toLowerCase(),
    );

    if (exists) return;

    final updated = [
      ...state.playlists,
      PlaylistModel(name: event.name, songs: []),
    ];

    await _save(updated);
    emit(state.copyWith(playlists: updated));
  }

  Future<void> _onAddSong(
    AddSongToPlaylistEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    final updated =
        state.playlists.map((playlist) {
          if (playlist.name == event.playlistName) {
            final exists = playlist.songs.any(
              (s) => s.name.toLowerCase() == event.song.name.toLowerCase(),
            );

            if (exists) return playlist;

            return PlaylistModel(
              name: playlist.name,
              songs: [...playlist.songs, event.song],
            );
          }
          return playlist;
        }).toList();

    await _save(updated);
    emit(state.copyWith(playlists: updated));
  }

  Future<void> _onRemoveSong(
    RemoveSongFromPlaylistEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    final updated =
        state.playlists.map((playlist) {
          if (playlist.name == event.playlistName) {
            return PlaylistModel(
              name: playlist.name,
              songs:
                  playlist.songs
                      .where((s) => s.name != event.song.name)
                      .toList(),
            );
          }
          return playlist;
        }).toList();

    await _save(updated);
    emit(state.copyWith(playlists: updated));
  }

  _onRemoveSongFromAllPlaylists(
    RemoveSongFromAllPlaylistsEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    final updatedPlaylists =
        state.playlists.map((playlist) {
          final updatedSongs =
              playlist.songs.where((s) => s.name != event.song.name).toList();

          return playlist.copyWith(songs: updatedSongs);
        }).toList();

    await _save(updatedPlaylists);

    emit(state.copyWith(playlists: updatedPlaylists));
  }
}
