import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Widgets/mobile_app_bar.dart';
import 'package:runo_music/Widgets/play_round_button.dart';

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

class Favourites extends StatefulWidget {

  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  String Fav_img = "https://m.media-amazon.com/images/G/01/ctt2309d82309/2022_en_US-UK-CA-AUNZ_MySoundtrack_PG_GH_2400x2400._UXNaN_FMjpg_QL85_.jpg";
  // @override
  // void initState()
  // {
  //   super.initState();
  //   var audiopro = Provider.of<FavouriteItemsProvider>(context, listen: false);
  //   favpro.loadFavouriteItems();
  // }


  @override
  Widget build(BuildContext context) {

    return Consumer2<FavouriteItemsProvider, AudioProvider>(builder: (context, favProvider,audioProvider, child)=>
        Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: !Responsive.isMobile() ? null:
            MobileAppBar(context,
                disablePop: true,
                actionIcon: Icons.filter_alt,
                actionOnPressed: (){
                  // customFilter.Filter(context: context);
                  customFilter.Filter(context: context, onSubmit : (selectedVal){favProvider.sortFavourites(selectedVal);});
                }
            ),
            backgroundColor: const Color.fromARGB(255, 18, 20, 25),
            body: Stack(children: [

              Image.network(
                Fav_img,
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
                                  Image.network(
                                    Fav_img,
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
                                    "Recently Played",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text('${audioProvider.recentPlayedItems.length} SONGS . ${((audioProvider.recentPlayedItems.length*30)/60).truncate()} MINS AND ${(audioProvider.recentPlayedItems.length*30)%60} SECS',
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
                                                  var items = audioProvider.recentPlayedItems.toList(growable: false);
                                                  audioProvider.toggleShuffle(context:context, itemsToShuffle: items);
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MusicPlayerView()),);
                                                }),
                                            iconButton(context:context, icon: Icons.file_download, onPressed: (){showMessage(context: context, content: "Functionality Not Exists");}),
                                            iconButton(context:context, icon: Icons.share, onPressed: (){showMessage(context: context, content: "Functionality Not Exists");})
                                          ],
                                        ),
                                        trailing:PlayRoundButton(items: audioProvider.recentPlayedItems.toList())
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
                                    "My Favourites",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  Text('${audioProvider.recentPlayedItems.length} SONGS . ${((audioProvider.recentPlayedItems.length*30)/60).truncate()} MINS AND ${(audioProvider.recentPlayedItems.length*30)%60} SECS',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 15
                                    ),
                                  ),
                                  PlayTextButton(trackList: audioProvider.recentPlayedItems.toList())
                                ],
                              ),
                            ),


                          ],
                        ):
                        Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Row(
                            children: [
                              Spacer(),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                SizedBox(
                                  height: 250,
                                  child: Image.network(
                                    Fav_img,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 40,),
                              SizedBox(
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "My Favourites",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('${audioProvider.recentPlayedItems.length} SONGS . ${((audioProvider.recentPlayedItems.length*30)/60).truncate()} MINS AND ${(audioProvider.recentPlayedItems.length*30)%60} SECS',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 15
                                      ),
                                    ),
                                    Container(
                                      width: 90,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: const Color.fromARGB(255, 11, 228, 228)
                                      ),
                                      child: TextButton(onPressed: () async{

                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MusicPlayerView()),);
                                        await audioProvider.loadAudio(trackList:audioProvider.recentPlayedItems.toList(growable: false),index:0);

                                      }, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [Icon(Icons.play_arrow, color: Colors.black87,), Text('Play', style: TextStyle(color: Colors.black87),)],)),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer()
                            ],
                          ),
                        )
                    )];
                },
                body: ListView.builder(
                    padding: EdgeInsets.all(0),
                    key: ValueKey(audioProvider.recentPlayedItems.length),
                    itemCount: audioProvider.recentPlayedItems.length,
                    itemBuilder: (context, index) {
                      return ListAllWidget(key:ValueKey(audioProvider.recentPlayedItems.toList()[index].id), index: index,items: audioProvider.recentPlayedItems.toList(growable: false), decorationReq: true,);

                    }),
              ),
            ]
            )
        )
    );

  }


}