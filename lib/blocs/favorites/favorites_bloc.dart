import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';
import 'package:music_player_app/models/song_info_model.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesState(favorites: [])) {
    on<LoadFavoritesEvent>(_onLoad);
    on<AddFavoriteEvent>(_onAdd);
    on<RemoveFavoriteEvent>(_onRemove);
  }

  Future<void> _onLoad(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("favorite_songs") ?? [];

    final favList =
        data.map((e) => SongInfoModel.fromJson(json.decode(e))).toList();

    emit(state.copyWith(favorites: favList, isLoading: false));
  }

  Future<void> _onAdd(
    AddFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final updated = List<SongInfoModel>.from(state.favorites)..add(event.song);
    event.song.isWishListed = true;
    // save to storage
    await prefs.setStringList(
      "favorite_songs",
      updated.map((e) => json.encode(e.toJson())).toList(),
    );

    emit(state.copyWith(favorites: updated));
  }

  Future<void> _onRemove(
    RemoveFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final updated = List<SongInfoModel>.from(state.favorites)
      ..removeWhere((s) => s.name == event.song.name);
    event.song.isWishListed = false;

    await prefs.setStringList(
      "favorite_songs",
      updated.map((e) => json.encode(e.toJson())).toList(),
    );

    emit(state.copyWith(favorites: updated));
  }
}
