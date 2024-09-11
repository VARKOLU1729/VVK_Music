import 'package:flutter/material.dart';
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import 'package:runo_music/Widgets/track_album_widget.dart';

class DisplayWithPagination extends StatelessWidget {
  final PagingController<int, dynamic> pagingController;
  final Type type;

  DisplayWithPagination({super.key, required this.pagingController, required this.type });

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
              items: pagingController.itemList!,
              type: type
            );
          })),
    );
  }
}
