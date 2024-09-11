import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Views/album_view.dart';
import 'package:runo_music/Views/music_player_view.dart';

enum Type { album, track }

class TrackAlbumWidget extends StatelessWidget {
  List<dynamic> items;
  final int index;
  final Type type;
  TrackAlbumWidget(
      {super.key,
        required this.index,
        required this.items,
        required this.type
      });
  Widget build(BuildContext context) {

    final String id = items![index][0];
    final String name = items![index][1];
    final String imageUrl = items![index][2];
    final String artistId = items![index][3];
    final String artistName = items![index][4];
    final String albumId = items![index][5];
    final String albumName = items![index][6];

    return InkWell(
      onTap: () {
        // print(trackName);
        if (type == Type.track)
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MusicPlayerView(
                index: index,
                items:items,
              )));

        else if (type == Type.album)
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AlbumView(
                  albumId: id,
                  albumName: name,
                  albumImageUrl: imageUrl,
                  artistId: artistId,
                  artistName: artistName
              )));
      },
      borderRadius: BorderRadius.circular(20),
      hoverColor: Color(0xff2d505e),
      child: Container(
        width: 180,
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Container(
              padding: EdgeInsets.all(5),
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
            ),
            Expanded(
                flex:2,
                child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            ))

          ],
        ),
      ),
    );
  }
}
