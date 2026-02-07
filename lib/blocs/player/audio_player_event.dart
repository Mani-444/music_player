import '../../models/song_info_model.dart';

abstract class AudioPlayerEvent {}

class PlaySongEvent extends AudioPlayerEvent {
  final SongInfoModel song;
  final int index;

  PlaySongEvent({required this.song, required this.index});
}

class PauseSongEvent extends AudioPlayerEvent {}

class StopSongEvent extends AudioPlayerEvent {}

class TogglePlayPauseEvent extends AudioPlayerEvent {}

class SeekSongEvent extends AudioPlayerEvent {
  final double position;

  SeekSongEvent(this.position);
}

class UpdateProgressEvent extends AudioPlayerEvent {
  final Duration position;

  UpdateProgressEvent(this.position);
}

class PlayNextSongEvent extends AudioPlayerEvent {}

class PlayPreviousSongEvent extends AudioPlayerEvent {}
