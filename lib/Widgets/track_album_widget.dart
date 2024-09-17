import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Helper/Responsive.dart';
import 'package:runo_music/Views/album_view.dart';
import 'package:runo_music/Views/music_player_view.dart';

import '../Views/artist_view.dart';
import 'favourite_items_provider.dart';

enum Type { album, track, artist }

class TrackAlbumWidget extends StatelessWidget {
  final List<dynamic> items;
  final int index;
  final Type type;
  const TrackAlbumWidget(
      {super.key,
      required this.index,
      required this.items,
      required this.type});

  @override
  Widget build(BuildContext context) {
    final String id = items[index].id;
    final String name = items[index].name;
    final String imageUrl = items[index].imageUrl;

    return InkWell(
      onTap: () async {
        // print(trackName);
        if (type == Type.track) {
          final audioProvider = Provider.of<AudioProvider>(context, listen: false);
          await audioProvider.loadAudio(trackList: items, index: index);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MusicPlayerView()),
          );
        } else if (type == Type.album)
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AlbumView(
                albumId: id,
                albumName: name,
                albumImageUrl: imageUrl,
                artistId: items[index].artistId,
                artistName: items[index].artistName);
          }));
        else if (type == Type.artist)
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ArtistView(
                    artistId: id,
                  )));
      },
      borderRadius: type == Type.artist
          ? BorderRadius.circular(100)
          : BorderRadius.circular(10),
      hoverColor: Color(0xff2d505e),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 8,
            child: Container(
              height:  Responsive.isSmallScreen(context) ? 220 :(Responsive.isMediumScreen(context)?230:260),
              padding: Responsive.isSmallScreen(context)
                  ? EdgeInsets.all(5)
                  : EdgeInsets.all(10),
              // decoration:type==Type.artist ? BoxDecoration(
              //     shape: BoxShape.circle,
              //     image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)):null,
              child:type==Type.artist? Container(
                width: Responsive.isSmallScreen(context) ? 170 :(Responsive.isMediumScreen(context)?170:190),
                decoration:BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)),
              ) : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: SizedBox(
                width: 160,
                child: Center(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
