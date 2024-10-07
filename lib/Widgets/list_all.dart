import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Helper/Responsive.dart';
import 'package:runo_music/Helper/deviceParams.dart';
import 'package:runo_music/Views/music_player_view.dart';
import 'package:runo_music/Services/Providers/provider.dart';
import 'package:runo_music/Widgets/create_playlist_dialog.dart';
import 'package:runo_music/audio_controllers/favourite_button.dart';
import 'package:runo_music/main.dart';
import 'package:runo_music/models/track_model.dart';

import '../Helper/messenger.dart';
import '../Views/same_view.dart';

class ListAllWidget extends StatefulWidget {
  final List<dynamic> items;
  final int index;
  final bool decorationReq;
  final PageType? pageType;
  const ListAllWidget({super.key, required this.items, required this.index,required this.decorationReq, this.pageType});

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


  Widget addToPlayList({
    required BuildContext context,
    required PlayListProvider plProvider,
    required TrackModel track,
  }) {
    List<String> playListNames = plProvider.getPlayListNames();

    return IconButton(
      icon: Icon(Icons.add, color: Colors.white),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(
                "Add To Playlist",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: playListNames.map((item) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(item, style: TextStyle(color: Colors.white)),
                          onTap: () {
                            if (!plProvider.checkInPlayList(name: item, trackId: track.id)) {
                              plProvider.addTrackToPlayList(context: context, name: item, track: track);
                            } else {
                              showMessage(context: context, content: "Song already exists in '$item'");
                            }
                            Navigator.of(context).pop(); // Close the dialog after adding
                          },
                        ),
                        Divider(color: Colors.grey, indent: 0,endIndent: 0,),
                      ],
                    );
                  }).toList(),
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actionsPadding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                TextButton(
                  onPressed: ()async {
                    String  playlistImage = 'assets/images/favouritesImage.webp';
                     await showCreatePlaylistDialog(context: context,
                        playListProvider: plProvider,
                        // onSave: (playListName)
                        // {
                        //   plProvider.createNewPlayList(name: playListName, imageUrl: playlistImage);
                        // }
                    );
                    context.pop();
                  },
                  child: Text("+ Create", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            );
          },
        );
      },
    );
  }


  // Widget addToPlayList({ required BuildContext context,required PlayListProvider plProvider,required TrackModel track})
  // {
  //   List<String> playListNames = plProvider.getPlayListNames();
  //   return  PopupMenuButton(
  //     offset: Offset(-15, 10),
  //           icon: Icon(Icons.add, color: Colors.white,),
  //         itemBuilder: (context)=>
  //         [
  //           const PopupMenuItem(
  //             enabled: false, // Disable selection for title
  //             child: Text(
  //               "Add To Playlist",
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 16,
  //                 color: Colors.white
  //               ),
  //             ),
  //           ),
  //           ...playListNames.map((item)=>PopupMenuItem(
  //             onTap:(){
  //               if(!plProvider.checkInPlayList(name: item, trackId: track.id))
  //               plProvider.addTrackToPlayList(context:context, name: item, track:track);
  //               else {
  //                 showMessage(context: context, content: "Song already exists in '$item'");
  //               }
  //               },
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text("$item"),
  //                   Divider(height: 8,thickness: 0,)
  //                 ],
  //               ))).toList()
  //         ]
  //       );
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer3<FavouriteItemsProvider, AudioProvider, PlayListProvider>(builder: (context, favProvider,audioProvider,playListProvider,  child){
      bool addedToFav = favProvider.checkInFav(id: id!);
      TrackModel track = TrackModel(id: id!, name: name!, artistId: artistId!, artistName: artistName!, albumId: albumId!, albumName: albumName!, imageUrl: imageUrl!);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
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
                trailing: SizedBox(
                  width: 72,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      favButton(onTap: () {
                        favProvider.toggleFavourite(
                            id: id!,
                            details: track,
                            context: context
                        );
                        setState(() {
                          addedToFav = !addedToFav;
                        });
                          },
                          addedToFav: addedToFav),
                      // IconButton(
                      //     onPressed: (){addToPlayList(context, playListProvider);},
                      //     icon: Icon(Icons.add, color: Colors.white,)
                      // )
                      widget.pageType!=null && widget.pageType==PageType.PlayList && playListProvider.currentName!=null && playListProvider.checkInPlayList(name: playListProvider.currentName!, trackId: track.id) ?

                      IconButton(icon: Icon(Icons.remove, color: Colors.white,),onPressed: (){playListProvider.removeFromPlaylist(context:context, name: playListProvider.currentName!, trackId: track.id);},) :

                      addToPlayList(context:context, plProvider: playListProvider,track: track)
                    ],
                  ),
                ),
              ),
              if(!Responsive.isMobile(context) && widget.decorationReq)
              Divider(indent: 20,endIndent: 20,height: 0,thickness: 0,color: Colors.grey,),
            ],
          ),
        );}
    );

  }


}
