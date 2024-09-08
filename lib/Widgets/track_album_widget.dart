import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Views/album_view.dart';
import 'package:runo_music/Views/music_player_view.dart';

enum Type { album, track }

class TrackAlbumWidget extends StatelessWidget {
  final PagingController<int, dynamic>? pagingController;
  List<dynamic>? items;
  final int index;
  final Type type;
  void Function(List<dynamic> item)? addToFavourite;
  TrackAlbumWidget(
      {super.key,
        required this.index,
        this.pagingController,
        this.items,
        required this.type,
        required this.addToFavourite,
      });

  Widget build(BuildContext context) {
    if(items==null)
      {
        items = pagingController!.itemList![index];
      }
    final String id = items![0];
    final String name = items![1];
    final String imageUrl = items![2];
    final String artistId = items![3];
    final String artistName = items![4];
    final String albumId = items![5];
    final String albumName = items![6];
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
                index: index,
                trackPagingController: pagingController,
                addToFavourite: addToFavourite!,
              )));

        if (type == Type.album)
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AlbumView(
                  albumId: id,
                  albumName: name,
                  albumImageUrl: imageUrl,
                  artistId: artistId,
                  artistName: artistName,
                  addToFavourite: addToFavourite!,
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
