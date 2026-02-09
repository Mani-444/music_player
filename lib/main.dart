import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/blocs/playlists/playlist_bloc.dart';
import 'package:music_player_app/blocs/playlists/playlist_event.dart';
import 'package:music_player_app/blocs/song/song_bloc.dart';
import 'package:music_player_app/blocs/song/song_event.dart';
import 'package:music_player_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SongBloc>(
          create: (_) => SongBloc()..add(LoadSongsEvent()),
        ),
        BlocProvider<PlaylistBloc>(
          create: (_) => PlaylistBloc()..add(LoadPlaylistsEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
