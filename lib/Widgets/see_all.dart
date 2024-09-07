import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Views/music_player_view.dart';
import 'package:runo_music/Widgets/pop_out.dart';

class SeeAll extends StatefulWidget {
  void Function(List<String> item) addToFavourite;
  final PagingController<int, dynamic> pagingController;

  SeeAll({required this.addToFavourite, required this.pagingController});
  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon:Icon(Icons.keyboard_arrow_left, color: Colors.white,size: 40,)
        ),
        backgroundColor: Colors.black.withOpacity(0.88),
        title: Text("Songs for You", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.abc_sharp))],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: PagedListView<int, dynamic>(
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
                  albumName: item[6],
                  addToFavourite: widget.addToFavourite);
            })),
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

class ListAllWidget extends StatefulWidget {
  final String id;
  final String name;
  final String imageUrl;
  final String artistId;
  final String artistName;
  final String albumId;
  final String albumName;
  final void Function(List<String> item) addToFavourite;
  const ListAllWidget(
      {super.key,
      required this.id,
      required this.name,
      required this.imageUrl,
      required this.artistId,
      required this.artistName,
      required this.albumId,
      required this.albumName,
      required this.addToFavourite});

  @override
  State<ListAllWidget> createState() => _ListAllWidgetState();
}

class _ListAllWidgetState extends State<ListAllWidget> {
  bool addedToFav = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MusicPlayerView(
                      trackId: widget.id,
                      trackName: widget.name,
                      trackImageUrl: widget.imageUrl,
                      artistId: widget.artistId,
                      artistName: widget.artistName,
                      albumId: widget.albumId,
                      albumName: widget.albumName,
                      addToFavourite: widget.addToFavourite)));
        },
        child: ListTile(
          leading: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            widget.name,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          subtitle: Text(widget.artistName,
              style: TextStyle(color: Colors.grey, fontSize: 13)),
          trailing: InkWell(
            onTap: () {
              widget.addToFavourite([
                widget.id,
                widget.name,
                widget.imageUrl,
                widget.artistId,
                widget.artistName,
                widget.albumId,
                widget.albumName
              ]);
              setState(() {
                addedToFav = !addedToFav;
                //add remove to fav here - if time is sufficient
              });
            },
            child: Icon(Icons.favorite,
                color: addedToFav ? Colors.red : Colors.white),
          ),
        ),
      ),
    );
  }
}
