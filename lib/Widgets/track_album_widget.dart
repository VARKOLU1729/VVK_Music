import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Views/album_view.dart';
import 'package:runo_music/Views/music_player_view.dart';

enum Type { album, track }

class TrackAlbumWidget extends StatelessWidget {
  final int? fav_index;
  final List<dynamic>? fav_items;
  final PagingController<int, dynamic>? pagingController;
  List<dynamic>? items;
  final int index;
  final Type type;
  TrackAlbumWidget(
      {super.key,
        required this.index,
        this.fav_index,
        this.fav_items,
        this.pagingController,
        this.items,
        required this.type
      });
  List<dynamic> fav_items_list = [];
  Widget build(BuildContext context) {

    if(items==null)
      {
        items = pagingController!.itemList!;
      }
    final String id = items![index][0];
    final String name = items![index][1];
    final String imageUrl = items![index][2];
    final String artistId = items![index][3];
    final String artistName = items![index][4];
    final String albumId = items![index][5];
    final String albumName = items![index][6];
    if(fav_index!=null)
    {
      fav_items_list.add(items![index]);
      print(fav_items_list);
    }
    return InkWell(
      onTap: () {
        // print(trackName);
        if(fav_index!=null)
          {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MusicPlayerView(
                  index: 0,
                  items: fav_items_list!,
                )));
          }
        else if (type == Type.track)

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MusicPlayerView(
                index: index,
                trackPagingController: pagingController
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
