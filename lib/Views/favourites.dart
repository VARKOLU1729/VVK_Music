import 'package:flutter/material.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';

class Favourites extends StatefulWidget {
  final List<List<String>> favourites;
  const Favourites({super.key, required this.favourites});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) => TrackAlbumWidget(
              id: widget.favourites[index][0],
              name: widget.favourites[index][0],
              imageUrl: widget.favourites[index][0],
              artistId: widget.favourites[index][0],
              artistName: widget.favourites[index][0],
              type: Type.track)),
    );
  }
}
