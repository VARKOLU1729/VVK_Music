import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Helper/loadingIndicator.dart';
import 'package:runo_music/Helper/sort.dart';
import 'package:runo_music/Widgets/mobile_app_bar.dart';
import 'package:runo_music/Widgets/play_round_button.dart';
import 'package:runo_music/models/track_model.dart';

import '../Helper/Responsive.dart';
import '../Helper/messenger.dart';
import '../Views/music_player_view.dart';

import '../Helper/deviceParams.dart';

import '../Widgets/albumContoller.dart';
import '../Widgets/list_all.dart';
import '../Widgets/back_ground_blur.dart';
import '../Services/Providers/provider.dart';
import '../Widgets/play_text_button.dart';
import '../Widgets/filter.dart' as customFilter;

enum PageType {Favourites, RecentlyPlayed, PlayList}

class SameView extends StatefulWidget {

  final PageType pageType;
  const SameView({super.key, required this.pageType});

  @override
  State<SameView> createState() => _SameViewState();
}

class _SameViewState extends State<SameView> {

  String recentsImage = "assets/images/recentsImage.webp";
  String favImage = "assets/images/favouritesImage.webp";
  String playListImage = "assets/images/favouritesImage.webp";
  String image = "assets/images/favouritesImage.webp" ;
  String title = "Default";
  String access = "Private";
  bool trackLoad = true;
  List<TrackModel> Items = [];
  void loadPlayListTracks() async
  {
    if(widget.pageType==PageType.PlayList)
      {
        PlayListProvider playListProvider = Provider.of<PlayListProvider>(context);
        Items = await playListProvider.getTrackList(name: playListProvider.currentName!);
        trackLoad = false;
        print("loaded");
      }
  }

  @override
  void initState()
  {
    super.initState();
    if(widget.pageType==PageType.Favourites)
      {
        var favpro = Provider.of<FavouriteItemsProvider>(context, listen: false);
        favpro.loadFavouriteItems();
      }
    // if(widget.pageType==PageType.PlayList)
    // {
    //   loadPlayListTracks();
    // }
  }


  @override
  Widget build(BuildContext context) {

    return Consumer3<FavouriteItemsProvider, AudioProvider, PlayListProvider>(builder: (context, favProvider,audioProvider,playListProvider, child){

      if(widget.pageType == PageType.Favourites)
        {
          title = "My Favourites";
          image = favImage;
          Items = favProvider.favouriteItems.values.toList(growable: false);
          access = "PRIVATE";
        }
      else if(widget.pageType == PageType.RecentlyPlayed)
      {
        title = "MY Recent Plays";
        image = recentsImage;
        Items =  audioProvider.recentPlayedItems.toList(growable: false);
        access = "PRIVATE";
      }
      else if(widget.pageType == PageType.PlayList)
      {
        title = playListProvider.currentName!;
        image = recentsImage;
        // loadPlayListTracks();
        playListProvider.setTrackList(name: playListProvider.currentName!);
        Items = playListProvider.getTracks;
        // Items =  playListProvider.getTrackList(name: playListProvider.currentName!);
        if(playListProvider.checkIfPublic(name: playListProvider.currentName!))
          {
            access = "PUBLIC";
          }
        else
          {
            access = "PRIVATE";
          }
      }
      return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: !Responsive.isMobile() ? null:
            MobileAppBar(context,
                disablePop: false,
                actionIcon: Icons.filter_alt,
                actionOnPressed: (){
                  customFilter.Filter(context: context,
                      onSubmit : (selectedVal){
                    if(widget.pageType==PageType.Favourites)
                    favProvider.sortFavourites(selectedVal);
                    if(widget.pageType==PageType.RecentlyPlayed)
                      audioProvider.sortRecents(selectedVal);
                    if(widget.pageType==PageType.PlayList)
                      playListProvider.sortItems(playListProvider.currentName!, selectedVal);
                  }
                  );
                }
            ),
            backgroundColor: const Color.fromARGB(255, 18, 20, 25),
            body: Stack(children: [

              Image.asset(
                image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              Container(
                margin: EdgeInsets.only(top: getHeight(context)/2),
                color: Colors.black.withOpacity(0.8),
              ),

              const BackGroundBlur(),

              NestedScrollView(
                headerSliverBuilder: (context, isScrolled)
                {
                  return [
                    SliverToBoxAdapter(

                        child: Responsive.isMobile(context)||Responsive.isSmallScreen(context) ?

                        Column(
                          children: [

                            SizedBox(height: 120,),

                            Center(
                              child: SizedBox(
                                height: 250,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                  Image.asset(
                                    image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20,),

                            Responsive.isMobile(context) ?

                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text('$access \u2022 ${Items.length} SONGS \u2022 ${((Items.length*30)/60).truncate()} MINS AND ${(Items.length*30)%60} SECS',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                        title:Row(
                                          children: [
                                            IconButton( icon: Icon(Icons.shuffle, color: Colors.white,),
                                                onPressed: ()async{
                                                  var items =Items;
                                                  audioProvider.toggleShuffle(context:context, itemsToShuffle: items);
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MusicPlayerView()),);
                                                }),
                                            iconButton(context:context, icon: Icons.file_download, onPressed: (){showMessage(context: context, content: "Functionality Not Exists");}),
                                            iconButton(context:context, icon: Icons.share, onPressed: (){showMessage(context: context, content: "Functionality Not Exists");})
                                          ],
                                        ),
                                        trailing:PlayRoundButton(items: Items)
                                    ),
                                  ),
                                ],
                              ),
                            ):

                            SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  Text('$access \u2022 ${Items.length} SONGS \u2022 ${((Items.length*30)/60).truncate()} MINS AND ${(Items.length*30)%60} SECS',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 15
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      PlayTextButton(trackList: Items),
                                      IconButton( icon: Icon(Icons.shuffle, color: Colors.white,),
                                          onPressed: ()async{
                                            var items =Items;
                                            audioProvider.toggleShuffle(context:context, itemsToShuffle: items);
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MusicPlayerView()),);
                                          }),
                                    ],
                                  )
                                ],
                              ),
                            ),


                          ],
                        ):
                        Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Row(
                            children: [
                              // Spacer(),
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(10),
                              //   child:
                              //   SizedBox(
                              //     height: 250,
                              //     child: Image.network(
                              //       Fav_img,
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(left: 60),
                                child: SizedBox(
                                  width: getWidth(context)<700 ? 250 : 300,
                                  height: getWidth(context)<700 ? 250 : 300,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 20, top: 20),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(image, fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(width: 40,),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('${Items.length} SONGS . ${((Items.length*30)/60).truncate()} MINS AND ${(Items.length*30)%60} SECS',
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.5),
                                            fontSize: 15
                                        ),
                                      ),
                                      SizedBox(height: Responsive.isLargeScreen(context)?20: 5,),
                                      Row(
                                        children: [
                                          PlayTextButton(trackList: Items),
                                          IconButton( icon: Icon(Icons.shuffle, color: Colors.white,),
                                              onPressed: ()async{
                                                var items =Items;
                                                audioProvider.toggleShuffle(context:context, itemsToShuffle: items);
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MusicPlayerView()),);
                                              }),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    )];
                },
                body:((widget.pageType==PageType.PlayList) || (widget.pageType==PageType.Favourites && !favProvider.isLoading) || (widget.pageType==PageType.RecentlyPlayed))
                    ?
                ListView.builder(
                    padding: EdgeInsets.only(top: 40),
                    key: ValueKey(Items.length),
                    itemCount: Items.length,
                    itemBuilder: (context, index) {
                      return ListAllWidget(key:ValueKey(Items[index].id), index: index,items: Items, decorationReq: true, pageType: widget.pageType,);

                    }):
                loadingIndicator(),
              ),
            ]
            )
        );}
    );

  }


}
