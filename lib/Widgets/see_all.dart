import 'package:flutter/material.dart';

class SeeAll extends StatefulWidget {
  final String id;
  final String name;
  final String imageUrl;
  final String artistId;
  final String artistName;
  final String albumId;
  final String albumName;
  final Type type;
  void Function(List<String> item) addToFavourite;
  SeeAll(
      {super.key,
        required this.addToFavourite,
        required this.id,
        required this.name,
        required this.imageUrl,
        required this.artistId,
        required this.artistName,
        required this.albumId,
        required this.type,
        required this.albumName
      });

  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  bool addedToFav = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListTile(
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
          children: [
            Text(widget.name),
            Text(widget.artistName)
          ],
        ),
        trailing: InkWell(
          onTap: (){
            widget.addToFavourite([widget.id, widget.name, widget.imageUrl, widget.artistId, widget.artistName, widget.albumId, widget.albumName]);
            setState(() {
              addedToFav = !addedToFav;
              //add remove to fav here - if time is sufficient
            });
          },
          child: Icon(Icons.favorite, color:addedToFav?Colors.red:Colors.white),
        ),
      ),
    );
  }
}
