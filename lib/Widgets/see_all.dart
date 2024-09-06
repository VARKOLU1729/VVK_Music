import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Views/music_player_view.dart';

class SeeAll extends StatefulWidget {

  void Function(List<String> item) addToFavourite;
  final PagingController<int, dynamic> pagingController;

  SeeAll({required this.addToFavourite,required this.pagingController});
  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 20, 25),
      body: PagedListView<int, dynamic>(
          pagingController: widget.pagingController,
          scrollDirection: Axis.vertical,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
              itemBuilder: (context, item, index) {
                return ListAllWidget(
                    id: item[0],
                    name: item[1],
                    imageUrl: item[2],
                    artistId: item[3],
                    artistName: item[4],
                    albumId: item[5],
                    albumName:item[6],
                    addToFavourite : widget.addToFavourite
                );
              })),
    );
  }
}

class ListAllWidget extends StatefulWidget {
  final String id;
  final String name;
  final String imageUrl;
  final String artistId;
  final String artistName;
  final String albumId;
  final String albumName;
  final void Function(List<String> item) addToFavourite;
  const ListAllWidget({
    super.key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.artistId,
    required this.artistName,
    required this.albumId,
    required this.albumName,
    required this.addToFavourite
  });

  @override
  State<ListAllWidget> createState() => _ListAllWidgetState();
}

class _ListAllWidgetState extends State<ListAllWidget> {
  bool addedToFav = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MusicPlayerView(trackId: widget.id, trackName:widget.name, trackImageUrl: widget.imageUrl, artistId: widget.artistId, artistName: widget.artistName, albumId: widget.albumId, albumName: widget.albumName, addToFavourite: widget.addToFavourite)));
      },
      child: ListTile(
        leading: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name, style: TextStyle(color: Colors.white),),
            Text(widget.artistName, style: TextStyle(color: Colors.white))
          ],
        ),
        trailing: InkWell(
          onTap: (){
            widget.addToFavourite([widget.id, widget.name, widget.imageUrl, widget.artistId, widget.artistName,widget.albumId,widget.albumName]);
            setState(() {
              addedToFav = !addedToFav;
              //add remove to fav here - if time is sufficient
            });
          },
          child: Icon(Icons.favorite, color:addedToFav?Colors.red:Colors.white),
        ),
      ),
    ) ;
  }
}



