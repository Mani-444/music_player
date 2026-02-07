import 'package:music_player_app/models/song_info_model.dart';

class SongState {
  final List<SongInfoModel> songs;

  SongState({required this.songs});

  SongState copyWith({List<SongInfoModel>? songs}) {
    return SongState(songs: songs ?? this.songs);
  }
}