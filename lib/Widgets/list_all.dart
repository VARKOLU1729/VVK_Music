import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Views/music_player_view.dart';

class ListAllWidget extends StatefulWidget {
  PagingController<int, dynamic>? pagingController;
  List<dynamic>? items;
  final int index;
  final void Function(List<dynamic> item) addToFavourite;
  ListAllWidget(
      {super.key,
      this.pagingController,
      this.items,
      required this.index,
      required this.addToFavourite});

  @override
  State<ListAllWidget> createState() => _ListAllWidgetState();
}

class _ListAllWidgetState extends State<ListAllWidget> {
  bool addedToFav = false;
  String? id;
  String? name;
  String? imageUrl;
  String? artistId;
  String? artistName;
  String? albumId;
  String? albumName;
  List<dynamic>? items;
  void loadData() {
    if (widget.items == null) {
      items = widget.pagingController!.itemList![widget.index];
    } else {
      items = widget.items![widget.index];
    }
    id = items![0];
    name = items![1];
    imageUrl = items![2];
    artistId = items![3];
    artistName = items![4];
    albumName = items![5];
    albumId = items![6];
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => widget.pagingController == null
                      ? MusicPlayerView(
                          items: widget.items,
                          index: widget.index,
                          addToFavourite: widget.addToFavourite)
                      : MusicPlayerView(
                          trackPagingController: widget.pagingController,
                          index: widget.index,
                          addToFavourite: widget.addToFavourite)));
        },
        child: ListTile(
          leading: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            name!,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          subtitle: Text(artistName!,
              style: TextStyle(color: Colors.grey, fontSize: 13)),
          trailing: InkWell(
            onTap: () {
              if(widget.items==null)
                {
                  widget.addToFavourite([widget.index, 1, widget.pagingController]);
                  setState(() {
                    addedToFav = !addedToFav;
                    //add remove to fav here - if time is sufficient
                  });
                }
              else
                {
                  widget.addToFavourite([widget.index, 0, widget.items]);
                  setState(() {
                    addedToFav = !addedToFav;
                    //add remove to fav here - if time is sufficient
                  });
                }

            },
            child: Icon(Icons.favorite,
                color: addedToFav ? Colors.red : Colors.white),
          ),
        ),
      ),
    );
  }
}
