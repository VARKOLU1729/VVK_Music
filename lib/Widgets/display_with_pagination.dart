import 'package:flutter/material.dart';
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import 'package:runo_music/Widgets/track_album_widget.dart';

import '../Helper/Responsive.dart';

class DisplayWithPagination extends StatelessWidget {
  final PagingController<int, dynamic> pagingController;
  final Type type;

  DisplayWithPagination({super.key, required this.pagingController, required this.type });

  @override
  Widget build(BuildContext context) {
    return Container(
      height:  Responsive.isSmallScreen(context) ? 220 :(Responsive.isMediumScreen(context)?230:260),
      padding: EdgeInsets.only(left: Responsive.isSmallScreen(context) ?15 :(Responsive.isMediumScreen(context)?40:60)),
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
