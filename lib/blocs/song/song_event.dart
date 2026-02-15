import 'package:music_player_app/models/song_info_model.dart';

abstract class SongEvent {}

class LoadSongsEvent extends SongEvent {}

class AddSongsEvent extends SongEvent {}

class DeleteSongEvent extends SongEvent {
  final SongInfoModel song;

  DeleteSongEvent(this.song);
}