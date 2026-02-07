import 'package:music_player_app/models/song_info_model.dart';

class FavoritesState {
  final List<SongInfoModel> favorites;
  final bool isLoading;

  FavoritesState({
    required this.favorites,
    this.isLoading = false,
  });

  FavoritesState copyWith({
    List<SongInfoModel>? favorites,
    bool? isLoading,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
