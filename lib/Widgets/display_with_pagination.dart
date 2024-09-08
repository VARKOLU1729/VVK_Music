import 'package:flutter/material.dart';
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import 'package:runo_music/Widgets/track_album_widget.dart';

class DisplayWithPagination extends StatelessWidget {
  final PagingController<int, dynamic> pagingController;
  final Type type;
  final void Function(List<dynamic> item) addToFavourites;

  DisplayWithPagination({super.key, required this.pagingController, required this.type, required this.addToFavourites });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: EdgeInsets.only(left: 15),
      child: PagedListView<int, dynamic>(
          pagingController: pagingController,
          scrollDirection: Axis.horizontal,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
              itemBuilder: (context, item, index) {
            return TrackAlbumWidget(
              index: index,
              pagingController: pagingController,
              type: type,
              addToFavourite : addToFavourites
            );
          })),
    );
  }
}
