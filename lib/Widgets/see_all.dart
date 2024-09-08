import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Widgets/list_all.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';

class SeeAll extends StatefulWidget {
  void Function(List<dynamic> item) addToFavourite;
  final Type type;
  final PagingController<int, dynamic> pagingController;

  SeeAll({required this.type, required this.addToFavourite, required this.pagingController});
  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  @override
  Widget build(BuildContext context) {
    String title = "Tracks for You";
    if(widget.type==Type.album) title = "Albums for You";
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        leading:
        IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon:Icon(Icons.keyboard_arrow_left, color: Colors.white,size: 40,)
        ),
        backgroundColor: Colors.black.withOpacity(0.88),
        title:
        Padding(
          padding: const EdgeInsets.only(top:5.0),
          child: Text(title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: widget.type==Type.track ? PagedListView<int, dynamic>(
            pagingController: widget.pagingController,
            scrollDirection: Axis.vertical,
            builderDelegate: PagedChildBuilderDelegate<dynamic>(
                itemBuilder: (context, item, index) {
              return
              ListAllWidget(
                  pagingController : widget.pagingController,
                  index:index,
                  addToFavourite: widget.addToFavourite) ;
            })) :
         PagedGridView<int, dynamic>(
             pagingController: widget.pagingController,
             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
             builderDelegate: PagedChildBuilderDelegate<dynamic>(
                 itemBuilder: (context, item, index){
                   print(index);
                   return TrackAlbumWidget(index: index, type: Type.album,pagingController: widget.pagingController, addToFavourite: widget.addToFavourite);
                 }
             )
         ),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                end: Alignment.topCenter,
                begin: Alignment.bottomCenter,
                colors: [
              Colors.black.withOpacity(0.99),
              Colors.black.withOpacity(0.92),
              Colors.black.withOpacity(0.9),
              Colors.black.withOpacity(0.88)
            ])),
      ),
    );
  }
}

