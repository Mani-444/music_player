// playlist_state.dart
import 'package:music_player_app/models/playlist_model.dart';

class PlaylistState {
  final List<PlaylistModel> playlists;

  PlaylistState({required this.playlists});

  PlaylistState copyWith({List<PlaylistModel>? playlists}) {
    return PlaylistState(playlists: playlists ?? this.playlists);
  }
}
