import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/blocs/favorites/favorites_bloc.dart';
import 'package:music_player_app/blocs/favorites/favorites_event.dart';
import 'package:music_player_app/blocs/favorites/favorites_state.dart';

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
                                    trailing: InkWell(
                                      onTap: () {
                                        showBottomSheet(
                                          context: context,
                                          builder: (bottomSheetContext) {
                                            return Container(
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
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
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
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 20),
                                                      Icon(
                                                        Icons.playlist_add,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 20),
                                                      Text(
                                                        'Add to queue',
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
                                                        Icons.playlist_add,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 20),
                                                      Text(
                                                        'Add to playlist',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      context
                                                          .read<FavoritesBloc>()
                                                          .add(
                                                            RemoveFavoriteEvent(
                                                              state
                                                                  .favorites[index],
                                                            ),
                                                          );
                                                      Navigator.pop(context);
                                                    },
                                                    child: Row(
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
                                                  ),
                                                  SizedBox(height: 10),
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
                                      state.favorites[index].name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder:
                                      //         (context) => PlayerScreen(index: index),
                                      //   ),
                                      // );
                                      // ref.read(homeProvider.notifier).playSound(index);
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
