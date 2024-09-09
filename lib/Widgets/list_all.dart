import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Views/music_player_view.dart';
import 'package:runo_music/Widgets/favourite_items_provider.dart';

import 'messenger.dart';

class ListAllWidget extends StatefulWidget {
  PagingController<int, dynamic>? pagingController;
  List<dynamic>? items;
  final int index;
  ListAllWidget(
      {super.key,
      this.pagingController,
      this.items,
      required this.index,
      });

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
      items = widget.pagingController!.itemList!;
    } else {
      items = widget.items!;
    }
    id = items![widget.index][0];
    name = items![widget.index][1];
    imageUrl = items![widget.index][2];
    artistId = items![widget.index][3];
    artistName = items![widget.index][4];
    albumName = items![widget.index][5];
    albumId = items![widget.index][6];
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<favouriteItemsProvider>(builder: (context, value, child){
      if(value.favourite_items.containsKey(id)) addedToFav=true;
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
                      )
                          : MusicPlayerView(
                        trackPagingController: widget.pagingController,
                        index: widget.index,
                      )));
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
                    setState(() {
                      addedToFav = !addedToFav;
                      if(addedToFav)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration:Duration(milliseconds: 30) ,content:addedSnackbarContent()));
                          value.addToFavourite(id: id!, details: [id, name,imageUrl, artistId, artistName, albumId, albumName]);
                        }
                      else
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration:Duration(milliseconds: 30), content:removedSnackbarContent()));
                          value.removeFromFavourite(id: id!);
                        }
                    });
                  },
                child: Icon(Icons.favorite,
                    color: addedToFav ? Colors.red : Colors.white),
              ),
            ),
          ),
        );}
    );



  }
}
