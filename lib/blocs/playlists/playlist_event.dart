// playlist_event.dart
import 'package:music_player_app/models/song_info_model.dart';

abstract class PlaylistEvent {}

class LoadPlaylistsEvent extends PlaylistEvent {}

class CreatePlaylistEvent extends PlaylistEvent {
  final String name;

  CreatePlaylistEvent(this.name);
}

class AddSongToPlaylistEvent extends PlaylistEvent {
  final String playlistName;
  final SongInfoModel song;

  AddSongToPlaylistEvent({required this.playlistName, required this.song});
}

class RemoveSongFromPlaylistEvent extends PlaylistEvent {
  final String playlistName;
  final SongInfoModel song;

  RemoveSongFromPlaylistEvent({required this.playlistName, required this.song});
}
