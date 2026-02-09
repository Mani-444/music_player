import 'package:music_player_app/models/song_info_model.dart';

class PlaylistModel {
  final String name;
  final List<SongInfoModel> songs;

  PlaylistModel({required this.name, required this.songs});

  Map<String, dynamic> toJson() => {
    'name': name,
    'songs': songs.map((e) => e.toJson()).toList(),
  };

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      name: json['name'],
      songs:
          (json['songs'] as List)
              .map((e) => SongInfoModel.fromJson(e))
              .toList(),
    );
  }
}
