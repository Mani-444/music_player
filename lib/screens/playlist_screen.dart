import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/blocs/playlists/playlist_bloc.dart';
import 'package:music_player_app/blocs/playlists/playlist_event.dart';
import 'package:music_player_app/blocs/playlists/playlist_state.dart';
import 'package:music_player_app/common_widgets/custom_text.dart';
import 'package:music_player_app/screens/detailed_playlist_screen.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<PlaylistBloc, PlaylistState>(
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
                // width: MediaQuery.of(context).size.width / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 40, right: 20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            CustomText('Playlists', fontSize: 20),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 0, right: 40),
                          child: InkWell(
                            onTap: () {
                              showCreatePlaylistDialog(context);
                            },
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) {
                          final playlist = state.playlists[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DetailedPlaylistScreen(
                                        playlist: playlist,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Icon(
                                    Icons.playlist_play,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 20),
                                  CustomText(playlist.name),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: state.playlists.length,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showCreatePlaylistDialog(BuildContext parentContext) {
    final controller = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const CustomText('New Playlist'),
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
