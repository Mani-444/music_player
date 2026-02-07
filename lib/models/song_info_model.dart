class SongInfoModel {
  String path;
  String name;
  bool? isPlaying;
  bool? isWishListed;
  double? duration;
  double? position;
  String? playlistName;

  SongInfoModel({
    required this.path,
    required this.name,
    this.isPlaying,
    this.isWishListed,
    this.duration,
    this.position,
    this.playlistName,
  });

  // Create SongInfo object from Map
  factory SongInfoModel.fromJson(Map<String, dynamic> map) {
    return SongInfoModel(
      path: map['path'],
      name: map['name'],
      isPlaying: map['isPlaying'] ?? false,
      isWishListed: map['isWishListed'] ?? false,
      duration: (map['duration'] ?? 0.0).toDouble(),
      position: (map['position'] ?? 0.0).toDouble(),
      playlistName: map['playlistName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'name': name,
      'isPlaying': isPlaying,
      'isWishListed': isWishListed,
      'duration': duration,
      'position': position,
      'playlistName': playlistName,
    };
  }

  SongInfoModel copyWith({
    String? path,
    String? name,
    bool? isPlaying,
    bool? isWishListed,
    double? duration,
    double? position,
    String? playlistName,
  }) {
    return SongInfoModel(
      path: path ?? this.path,
      name: name ?? this.name,
      isPlaying: isPlaying ?? this.isPlaying,
      isWishListed: isWishListed ?? this.isWishListed,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      playlistName: playlistName ?? this.playlistName,
    );
  }
}
