import '../../models/song_info_model.dart';

class AudioPlayerState {
  final SongInfoModel? currentSong;
  final bool isPlaying;
  final double position;
  final double duration;

  const AudioPlayerState({
    this.currentSong,
    this.isPlaying = false,
    this.position = 0,
    this.duration = 0,
  });

  AudioPlayerState copyWith({
    SongInfoModel? currentSong,
    bool? isPlaying,
    double? position,
    double? duration,
  }) {
    return AudioPlayerState(
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}
