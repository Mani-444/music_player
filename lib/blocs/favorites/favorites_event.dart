import 'package:music_player_app/models/song_info_model.dart';

abstract class FavoritesEvent {}

// Load favorites from SharedPreferences
class LoadFavoritesEvent extends FavoritesEvent {}

// Add a song to favorites
class AddFavoriteEvent extends FavoritesEvent {
  final SongInfoModel song;
  AddFavoriteEvent(this.song);
}

// Remove a song from favorites
class RemoveFavoriteEvent extends FavoritesEvent {
  final SongInfoModel song;
  RemoveFavoriteEvent(this.song);
}
