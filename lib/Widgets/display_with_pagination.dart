import 'package:flutter/material.dart';
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import 'package:runo_music/Helper/loadingIndicator.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';

import '../Helper/Responsive.dart';

class DisplayWithPagination extends StatelessWidget {
  final PagingController<int, dynamic> pagingController;
  final ScrollController? scrollController;
  final Type type;

  const DisplayWithPagination({super.key, required this.pagingController, required this.type, this.scrollController });


  @override
  Widget build(BuildContext context) {
    return Container(
      height:  Responsive.isSmallScreen(context) || Responsive.isMobile(context) ? 220 :(Responsive.isMediumScreen(context)?230:260),
      padding: EdgeInsets.only(
          left: Responsive.isSmallScreen(context) || Responsive.isMobile(context) ?15 :(Responsive.isMediumScreen(context)?40:60),
        right: Responsive.isSmallScreen(context) || Responsive.isMobile(context) ?0:(Responsive.isMediumScreen(context)?20:40)
      ),
      child: PagedListView<int, dynamic>(
          pagingController: pagingController,
          scrollDirection: Axis.horizontal,
          scrollController: scrollController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            firstPageProgressIndicatorBuilder: (context)=> loadingIndicator(),
              newPageProgressIndicatorBuilder: (context)=> loadingIndicator(),
              noItemsFoundIndicatorBuilder: (context)=>Center(child: Text("No Items found", style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),),
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
