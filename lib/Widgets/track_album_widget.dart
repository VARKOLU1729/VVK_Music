import 'package:flutter/material.dart';
import 'package:runo_music/Views/album_view.dart';
import 'package:runo_music/Views/music_player_view.dart';

enum Type { album, track }

class TrackAlbumWidget extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  final String artistId;
  final String artistName;
  final Type type;
  const TrackAlbumWidget(
      {super.key,
        required this.id,
        required this.name,
        required this.imageUrl,
        required this.artistId,
        required this.artistName,
        required this.type});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // print(trackName);
        if (type == Type.track)
          // showModalBottomSheet(
          //     context: context,
          //     builder: (context) => MusicPlayerView(
          //         trackId: id,
          //         trackName: name,
          //         trackImageUrl: imageUrl,
          //         artistId: artistId,
          //         artistName: artistName));
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MusicPlayerView(
                  trackId: id,
                  trackName: name,
                  trackImageUrl: imageUrl,
                  artistId: artistId,
                  artistName: artistName)));

        if (type == Type.album)
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AlbumView(
                  albumId: id,
                  albumName: name,
                  albumImageUrl: imageUrl,
                  artistId: artistId,
                  artistName: artistName)));
      },
      borderRadius: BorderRadius.circular(20),
      hoverColor: Color(0xff2d505e),
      child: Container(
        width: 180,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              // decoration: BoxDecoration(
              //   shape: BoxShape.rectangle,
              //   borderRadius: BorderRadius.circular(20),
              // ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
