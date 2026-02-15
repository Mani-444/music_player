import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/blocs/favorites/favorites_bloc.dart';
import 'package:music_player_app/blocs/favorites/favorites_event.dart';
import 'package:music_player_app/blocs/playlists/playlist_bloc.dart';
import 'package:music_player_app/blocs/playlists/playlist_event.dart';
import 'package:music_player_app/blocs/playlists/playlist_state.dart';
import 'package:music_player_app/blocs/song/song_bloc.dart';
import 'package:music_player_app/blocs/song/song_event.dart';
import 'package:music_player_app/blocs/song/song_state.dart';
import 'package:music_player_app/common_widgets/custom_music_action_widget.dart';
import 'package:music_player_app/common_widgets/custom_text.dart';
import 'package:music_player_app/models/song_info_model.dart';
import 'package:music_player_app/screens/favorite_screen.dart';
import 'package:music_player_app/screens/player_screen.dart';
import 'package:music_player_app/screens/playlist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<SongBloc, SongState>(
          // bloc: songBloc,
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
                        CustomText('Meloplay', fontSize: 20),
                        SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            context.read<SongBloc>().add(AddSongsEvent());
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
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (bottomSheetContext) {
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
                                                Navigator.pop(
                                                  bottomSheetContext,
                                                );
                                              },
                                              child: CustomText('Cancel'),
                                            ),
                                            // InkWell(
                                            //   onTap: () {
                                            //     ///Todo
                                            //   },
                                            //   child: Row(
                                            //     children: [
                                            //       SizedBox(width: 20),
                                            //       CustomText('Add to queue'),
                                            //     ],
                                            //   ),
                                            // ),
                                            // SizedBox(height: 10),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(
                                                  bottomSheetContext,
                                                );
                                                showAddToPlaylistSheet(
                                                  context,
                                                  state.songs[index],
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 20),
                                                  CustomText('Add to playlist'),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            InkWell(
                                              onTap: () {
                                                context.read<SongBloc>().add(
                                                  DeleteSongEvent(
                                                    state.songs[index],
                                                  ),
                                                );
                                                context.read<PlaylistBloc>().add(
                                                  RemoveSongFromAllPlaylistsEvent(
                                                    state.songs[index],
                                                  ),
                                                );
                                                context
                                                    .read<FavoritesBloc>()
                                                    .add(
                                                      RemoveFavoriteEvent(
                                                        state.songs[index],
                                                      ),
                                                    );
                                                Navigator.pop(
                                                  bottomSheetContext,
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 20),
                                                  Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 20),
                                                  CustomText('Delete'),
                                                ],
                                              ),
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
                                                CustomText('Share'),
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
                              title: CustomText(state.songs[index].name),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PlayerScreen(
                                          index: index,
                                          songs: state.songs,
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        itemCount: state.songs.length,
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

  void showAddToPlaylistSheet(BuildContext parentContext, SongInfoModel song) {
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: parentContext.read<PlaylistBloc>(),
          child: BlocBuilder<PlaylistBloc, PlaylistState>(
            builder: (_, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.add, color: Colors.white),
                    title: const CustomText('Create new playlist'),
                    onTap: () {
                      Navigator.pop(sheetContext); // ✅ close sheet first

                      // ✅ wait until widget tree stabilizes
                      Future.microtask(() {
                        showCreatePlaylistDialog(parentContext);
                      });
                    },
                  ),
                  ...state.playlists.map(
                    (playlist) => ListTile(
                      title: CustomText(playlist.name),
                      onTap: () {
                        parentContext.read<PlaylistBloc>().add(
                          AddSongToPlaylistEvent(
                            playlistName: playlist.name,
                            song: song,
                          ),
                        );

                        Navigator.pop(sheetContext);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void showCreatePlaylistDialog(BuildContext parentContext) {
    final controller = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: CustomText('New Playlist'),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Playlist name',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isEmpty) return;

                if (!parentContext.mounted) return; // ✅ safety

                parentContext.read<PlaylistBloc>().add(
                  CreatePlaylistEvent(name),
                );

                Navigator.pop(dialogContext);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
