import 'dart:core';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Views/same_view.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';

import '../Helper/Responsive.dart';
import '../Services/Providers/provider.dart';
import '../Widgets/mobile_app_bar2.dart';
import '../models/play_list_model.dart';


class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {

  String playlistImage = "assets/images/favouritesImage.webp";
  
  @override
  Widget build(BuildContext context) {
    return Consumer3<FavouriteItemsProvider, AudioProvider, PlayListProvider>(builder: (context, favProvider,audioProvider,playListProvider, child)=>Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar:Responsive.isMobile() ? MobileAppBar2(context):null,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              SizedBox(height: 100,),
        
              if(Responsive.isMobile())
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading:  InkWell(
                  mouseCursor: MouseCursor.uncontrolled,
                  onTap: (){context.push('/profile-view');},
                  child: Container(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        child: Icon(Icons.person, size: 50,color: Colors.white.withOpacity(0.5),),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                              Colors.orange.withOpacity(0.9), Colors.red.withOpacity(0.9)
                            ])
                        ),
                      ),
                    ),
        
                  ),
                  // child: ClipOval(
                  //     child: Image.asset(
                  //       'assets/images/profile_image.png',
                  //       width: 30,
                  //       height: 30,
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                ),
                title: Text("My Library", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
              ),
        
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
        
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Header(title: "Playlists"),
                        FilledButton(
                          style: ButtonStyle(
                            visualDensity: VisualDensity(vertical: -3),
                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.tertiary),
                            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 0, horizontal: 15)),
                          ),
                            onPressed: (){
                              showDialog(
                                  context: context,
                                  builder: (context)
                                  {
                                    String enteredName = "";
                                    bool entered = false;
                                    return AlertDialog(
                                      backgroundColor: Colors.black87,
                                      actions: [
                                        FilledButton(
                                          style:ButtonStyle(
                                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.tertiary),
                                          ),
                                            onPressed: (){
                                            if(entered)
                                              setState(() {
                                                playListProvider.createNewPlayList(name: enteredName, imageUrl: playlistImage);
                                              });
                                              context.pop();
                                            },
                                            child: Text("Save", style: TextStyle(color: Colors.black87),)
                                        ),
                                        IconButton(
                                            onPressed: (){
                                              context.pop();
                                            },
                                            icon: Icon(Icons.exit_to_app, color: Colors.white,))
                                      ],
                                      title: Center(child: Text("Create New Playlist", style: TextStyle(color: Colors.white, fontSize: 15),)),
                                      content: TextField(
                                        decoration: InputDecoration(
                                          hintText: "Playlist Name ...",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: OutlineInputBorder(),
                                        ),
                                        style: TextStyle(color: Colors.white, fontSize: 10),
                                        onChanged: (val){
                                         if(val.length>=1)
                                           {
                                             setState(() {
                                               enteredName = val;
                                               entered=true;
                                             });
                                           }
                                        },
                                      ),
                                    );
                                  }
                              );
                            },
                            child: Text("+ NEW PLAYLIST", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold,fontSize: 12),),
                        )
                      ],
                    ),
        
                    SizedBox(height: 15,),
        
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Item(Url: "assets/images/favouritesImage.webp", Title: "My Favourites", pageType: PageType.Favourites),
                          for(int i=0; i<playListProvider.playLists.length; i++)
                          playListProvider.playLists.values.map((playlist)=>Item(Title: playlist.name, Url: playlist.imageUrl, pageType: PageType.PlayList, playListName: playlist.name)).toList()[i]
                        ],
                      ),
                    ),
        
                    SizedBox(height: 15,),
        
                    Header(title: "Made for you"),
        
                    SizedBox(height: 15,),
        
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
        
        
                          Item(Url: "assets/images/favouritesImage.webp", Title: "My Favourites", pageType: PageType.Favourites),
        
                          SizedBox(width: 10,),
        
                          Item(Url: "assets/images/recentsImage.webp", Title: "My Recent Plays", pageType: PageType.RecentlyPlayed),
        
        
                        ],
                      ),
                    ),
        
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
  
  Widget Header({required String title})
  {
    return Text("$title", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),);
  }

  Widget Item({required String Url, required String Title, required PageType pageType, String playListName='null'})
  {
    PlayListProvider playListProvider = Provider.of<PlayListProvider>(context);
    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 8,
              child: InkWell(
                onTap: (){
                  if(pageType==PageType.PlayList)  playListProvider.setCurrentName(playListName);
                  context.push('/same-view', extra: {'pageType':pageType}); },
                child: SizedBox(
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                    Image.asset(
                      Url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          ),
          Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: SizedBox(
                  width: 160,
                  child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "PLAYLIST\n", style: TextStyle(fontSize: 8,fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary)),
                          TextSpan(text: Title ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400))
                        ]
                      )
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

}
