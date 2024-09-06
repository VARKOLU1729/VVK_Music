import 'package:flutter/material.dart';
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import 'package:runo_music/Widgets/track_album_widget.dart';

class DisplayWithPagination extends StatelessWidget {
  final PagingController<int, dynamic> pagingController;
  final Type type;
  final void Function(List<String> item) addToFavourites;

  DisplayWithPagination({super.key, required this.pagingController, required this.type, required this.addToFavourites });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: PagedListView<int, dynamic>(
          pagingController: pagingController,
          scrollDirection: Axis.horizontal,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
              itemBuilder: (context, item, index) {
            return TrackAlbumWidget(
              id: item[0],
              name: item[1],
              imageUrl: item[2],
              artistId: item[3],
              artistName: item[4],
              albumId: item[5],
              albumName:item[6],
              type: type,
              addToFavourite : addToFavourites
            );
          })),
    );
  }
}
