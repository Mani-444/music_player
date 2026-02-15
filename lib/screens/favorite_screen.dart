import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/blocs/favorites/favorites_bloc.dart';
import 'package:music_player_app/blocs/favorites/favorites_event.dart';
import 'package:music_player_app/blocs/favorites/favorites_state.dart';
import 'package:music_player_app/common_widgets/custom_text.dart';
import 'package:music_player_app/screens/player_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (_) => FavoritesBloc()..add(LoadFavoritesEvent()),
          child: BlocConsumer<FavoritesBloc, FavoritesState>(
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
                      Padding(
                        padding: EdgeInsets.only(left: 40),
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
                      SizedBox(height: 20),
                      state.favorites.isNotEmpty
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
                                    title: CustomText(
                                      state.favorites[index].name,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => PlayerScreen(
                                                index: index,
                                                songs: state.favorites,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              itemCount: state.favorites.length,
                            ),
                          )
                          : Expanded(
                            child: Center(child: Text('No Favorites')),
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
}
