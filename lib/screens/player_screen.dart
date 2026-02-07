
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/blocs/favorites/favorites_bloc.dart';
import 'package:music_player_app/blocs/favorites/favorites_event.dart';
import 'package:music_player_app/blocs/favorites/favorites_state.dart';
import 'package:music_player_app/blocs/player/audio_player_bloc.dart';
import 'package:music_player_app/blocs/player/audio_player_event.dart';
import 'package:music_player_app/blocs/player/audio_player_state.dart';
import 'package:music_player_app/models/song_info_model.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key, required this.index, required this.songs});

  final int index;
  final List<SongInfoModel> songs;

  @override
  Widget build(BuildContext context) {
    final song = songs[index];
    return SafeArea(
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) =>
            AudioPlayerBloc(songs)
              ..add(PlaySongEvent(song: song, index: index))),
            BlocProvider(create: (context) => FavoritesBloc()..add(LoadFavoritesEvent()))
          ],
          child: BlocConsumer<AudioPlayerBloc, AudioPlayerState>(
            builder: (context, state) {
              final playerBloc = context.read<AudioPlayerBloc>();
              final currentSong = state.currentSong;
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple.shade300, Colors.red.shade500],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  // width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            playerBloc.add(StopSongEvent());
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.audiotrack_outlined,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width: 30),
                          Expanded(
                            flex: 6,
                            child: Text(
                              currentSong?.name ?? '-',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: BlocBuilder<FavoritesBloc, FavoritesState>(
                              builder: (context,favState) {
                                final isFav = favState.favorites
                                    .any((s) => s.path == currentSong?.path);
                                return InkWell(
                                  onTap: () {
                                    if (isFav) {
                                      context.read<FavoritesBloc>().add(RemoveFavoriteEvent(currentSong??SongInfoModel(path: '', name: '')));
                                    } else {
                                      context.read<FavoritesBloc>().add(AddFavoriteEvent(currentSong??SongInfoModel(path: '', name: '')));
                                    }
                                  },
                                  child:
                                      isFav
                                          ? Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                          )
                                          : Icon(
                                            Icons.favorite_border,
                                            color: Colors.white,
                                          ),
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Slider(
                        min: 0.0,
                        max: state.duration,
                        value: state.position.clamp(0.0, state.duration),
                        onChanged: (value) {
                          playerBloc.add(SeekSongEvent(value));
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(state.position),
                              /* ref
                            .read(homeProvider.notifier)
                            .formatTime(
                              home[ref.read(homeProvider.notifier).selectedIndex]
                                      .position ??
                                  0,
                            )*/
                              style: TextStyle(color: Colors.white),
                            ),

                            Text(
                              _formatDuration(state.duration),
                              /* ref
                            .read(homeProvider.notifier)
                            .formatTime(
                              home[ref.read(homeProvider.notifier).selectedIndex]
                                      .duration ??
                                  0,
                            )*/
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              // index = Random().nextInt(home.length - 1);
                              // ref.read(homeProvider.notifier).playSound(index);
                            },
                            child: Icon(
                              Icons.shuffle,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              playerBloc.add(PlayPreviousSongEvent());
                            },
                            child: Icon(
                              Icons.skip_previous,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              playerBloc.add(TogglePlayPauseEvent());
                            },
                            child:
                                state.isPlaying
                                    ? Icon(
                                      Icons.pause,
                                      size: 25,
                                      color: Colors.white,
                                    )
                                    : Icon(
                                      Icons.play_arrow,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                          ),
                          InkWell(
                            onTap: () {
                              playerBloc.add(PlayNextSongEvent());
                            },
                            child: Icon(
                              Icons.skip_next,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.queue_music,
                            size: 25,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            listener: (context, state) => SizedBox(),
          ),
        ),
      ),
    );
  }

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }
}
