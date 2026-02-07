import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/blocs/favorites/favorites_bloc.dart';
import 'package:music_player_app/blocs/favorites/favorites_event.dart';
import 'package:music_player_app/blocs/player/audio_player_bloc.dart';
import 'package:music_player_app/blocs/player/audio_player_event.dart';
import 'package:music_player_app/blocs/song/song_bloc.dart';
import 'package:music_player_app/blocs/song/song_event.dart';
import 'package:music_player_app/blocs/song/song_state.dart';
import 'package:music_player_app/common_widgets/custom_music_action_widget.dart';
import 'package:music_player_app/screens/favorite_screen.dart';
import 'package:music_player_app/screens/player_screen.dart';
import 'package:music_player_app/screens/playlist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final songBloc = SongBloc()..add(LoadSongsEvent());
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<SongBloc, SongState>(
          bloc: songBloc,
          builder: (context, state) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple.shade300, Colors.red.shade500],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Meloplay',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            // ref.read(homeProvider.notifier).fetchList();
                            songBloc.add(AddSongsEvent());
                          },
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 20),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FavoriteScreen(),
                                ),
                              );
                            },
                            child: CustomMusicActionWidget(
                              icon: Icons.favorite,
                              label: 'Favorites',
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaylistScreen(),
                                ),
                              );
                            },
                            child: CustomMusicActionWidget(
                              icon: Icons.playlist_play,
                              label: 'Playlists',
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: CustomMusicActionWidget(
                            icon: Icons.timelapse,
                            label: 'Recents',
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              trailing: InkWell(
                                onTap: () {
                                  showBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        // width: MediaQuery.of(context).size.width / 3,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.black45,
                                            ),
                                            left: BorderSide(
                                              color: Colors.black45,
                                            ),
                                            right: BorderSide(
                                              color: Colors.black45,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                ///Todo
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 20),
                                                  Text(
                                                    'Add to queue',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            InkWell(
                                              onTap: () {
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder:
                                                //         (context) => PlaylistScreen(),
                                                //   ),
                                                // );
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 20),
                                                  Text(
                                                    'Add to playlist',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                SizedBox(width: 20),
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 20),
                                                Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                SizedBox(width: 20),
                                                Icon(
                                                  Icons.share,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 20),
                                                Text(
                                                  'Share',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                              ),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.audiotrack_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                state.songs[index].name,
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                // ref.read(homeProvider.notifier).playSound(index);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider(
                                              create: (_) => AudioPlayerBloc(state.songs)
                                                ..add(PlaySongEvent(song: state.songs[index], index: index)),
                                            ),
                                            BlocProvider(
                                              create: (_) => FavoritesBloc()
                                                ..add(LoadFavoritesEvent()), // 🔥 IMPORTANT
                                            ),
                                          ],
                                          child: PlayerScreen(
                                            index: index,
                                            songs: state.songs,
                                          ),
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        itemCount: state.songs.length /*home.length,*/,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          listener: (context, state) => SizedBox(),
        ),
      ),
    );
  }
}
