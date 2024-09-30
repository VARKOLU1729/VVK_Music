import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Helper/Responsive.dart';
import 'package:runo_music/Views/music_player_view.dart';
import 'package:runo_music/Services/Providers/provider.dart';
import 'package:runo_music/audio_controllers/favourite_button.dart';
import 'package:runo_music/main.dart';
import 'package:runo_music/models/track_model.dart';

import '../Helper/messenger.dart';

class ListAllWidget extends StatefulWidget {
  final List<dynamic> items;
  final int index;
  final bool decorationReq;
  const ListAllWidget({super.key, required this.items, required this.index,required this.decorationReq});

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
  void loadData() {
    id = widget.items[widget.index].id;
    name = widget.items[widget.index].name;
    imageUrl = widget.items[widget.index].imageUrl;
    artistId = widget.items[widget.index].artistId;
    artistName = widget.items[widget.index].artistName;
    albumName = widget.items[widget.index].albumName;
    albumId = widget.items[widget.index].albumId;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FavouriteItemsProvider, AudioProvider>(builder: (context, favProvider,audioProvider,  child){
      bool addedToFav = favProvider.checkInFav(id: id!);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: [
              ListTile(
                onTap: () async{
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MusicPlayerView()),);
                  context.push('/music-player');
                  await audioProvider.loadAudio(trackList:widget.items,index: widget.index);
                },
                hoverColor: Colors.red,
                key: ValueKey(id),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if(!Responsive.isMobile(context) && widget.decorationReq)
                    Text('${widget.index+1}', style: TextStyle(color: Colors.white, fontSize: 15),),
                    Padding(
                      padding:EdgeInsets.only(left: Responsive.isMobile(context)? 10:20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(
                  name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                subtitle: Text(artistName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
                trailing: favButton(onTap: () {
                  favProvider.toggleFavourite(
                      id: id!,
                      details: TrackModel(id: id!, name: name!, artistId: artistId!, artistName: artistName!, albumId: albumId!, albumName: albumName!, imageUrl: imageUrl!),
                      context: context);
                  setState(() {
                    addedToFav = !addedToFav;
                  });
                    },
                    addedToFav: addedToFav),
              ),
              if(!Responsive.isMobile(context) && widget.decorationReq)
              Divider(indent: 20,endIndent: 20,height: 0,thickness: 0,color: Colors.grey,),
            ],
          ),
        );}
    );



  }
}
