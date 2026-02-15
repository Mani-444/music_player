import 'package:flutter/material.dart';
import 'package:music_player_app/common_widgets/custom_text.dart';
import 'package:music_player_app/models/playlist_model.dart';
import 'package:music_player_app/screens/player_screen.dart';

class DetailedPlaylistScreen extends StatelessWidget {
  const DetailedPlaylistScreen({super.key, required this.playlist});

  final PlaylistModel playlist;

  @override
  Widget build(BuildContext context) {
    final songs = playlist.songs;
    return SafeArea(
      child: Scaffold(
        body: Center(
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
                    },
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                SizedBox(height: 20),
                (songs.isNotEmpty)
                    ? Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: ListTile(
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
                              title: CustomText(songs[index].name),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PlayerScreen(
                                          index: index,
                                          songs: songs,
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        itemCount: songs.length,
                      ),
                    )
                    : Expanded(child: Center(child: Text('No Songs'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
