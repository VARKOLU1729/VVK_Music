import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Widgets/mobile_app_bar.dart';
import 'package:runo_music/Widgets/play_round_button.dart';

import '../Helper/Responsive.dart';
import '../Views/music_player_view.dart';

import '../Helper/deviceParams.dart';

import '../Widgets/list_all.dart';
import '../Widgets/back_ground_blur.dart';
import '../Services/Providers/provider.dart';
import '../Widgets/play_text_button.dart';

class Favourites extends StatefulWidget {

  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  String Fav_img = "https://m.media-amazon.com/images/G/01/ctt2309d82309/2022_en_US-UK-CA-AUNZ_MySoundtrack_PG_GH_2400x2400._UXNaN_FMjpg_QL85_.jpg";

  @override
  void initState()
  {
    var favpro = Provider.of<FavouriteItemsProvider>(context);
    favpro.loadFavouriteItems();
  }


  @override
  Widget build(BuildContext context) {

    return Consumer2<FavouriteItemsProvider, AudioProvider>(builder: (context, favProvider,audioProvider, child)=>Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: Responsive.isMobile() ? MobileAppBar(context, disablePop: true):null,
        backgroundColor: const Color.fromARGB(200, 9, 3, 3),
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
                        SizedBox(
                          height: 120,
                        ),
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
                                "My Favourites",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text('${favProvider.favouriteItems.length} SONGS . ${((favProvider.favouriteItems.length*30)/60).truncate()} MINS AND ${(favProvider.favouriteItems.length*30)%60} SECS',
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
                                        IconButton(onPressed: (){}, icon: Icon(Icons.shuffle, color: Colors.white,)),
                                        IconButton(onPressed: (){}, icon: Icon(Icons.favorite_outline, color: Colors.white,)),
                                        IconButton(onPressed: (){}, icon: Icon(Icons.file_download, color: Colors.white,)),
                                        IconButton(onPressed: (){}, icon: Icon(Icons.share, color: Colors.white,))
                                      ],
                                    ),
                                    trailing:PlayRoundButton(items: favProvider.favouriteItems.values.toList())
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

                              Text('${favProvider.favouriteItems.length} SONGS . ${((favProvider.favouriteItems.length*30)/60).truncate()} MINS AND ${(favProvider.favouriteItems.length*30)%60} SECS',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 15
                                ),
                              ),
                              PlayTextButton(trackList: favProvider.favouriteItems.values.toList())
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
                                Text('${favProvider.favouriteItems.length} SONGS . ${((favProvider.favouriteItems.length*30)/60).truncate()} MINS AND ${(favProvider.favouriteItems.length*30)%60} SECS',
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
                                    await audioProvider.loadAudio(trackList:favProvider.favouriteItems.values.toList(growable: false),index:0);

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
                key: ValueKey(favProvider.favouriteItems.length),
                itemCount: favProvider.favouriteItems.length,
                itemBuilder: (context, index) {
                  return ListAllWidget(index: index,items: favProvider.favouriteItems.values.toList(growable: false), decorationReq: true,);

                }),
          ),
        ]
        )
    )
    );
    
  }
}








//     Scaffold(
//   appBar: Responsive.isMobile() ?  MobileAppBar(context, disablePop: true) : null,
//
//     extendBodyBehindAppBar: true,
//     extendBody: true,
//     body: Stack(
//       children: [
//         Image.network(
//           Fav_img,
//           width: double.infinity,
//           height: double.infinity,
//           fit: BoxFit.cover,
//         ),
//
//         Container(
//           margin: EdgeInsets.only(top: getHeight(context)/2),
//           color: Colors.black,
//         ),
//
//         const BackGroundBlur(),
//
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(
//               height: 100,
//             ),
//             Expanded(
//               flex: 2,
//               child: Center(
//                 child: SizedBox(
//                   height: 250,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.network(
//                       Fav_img,
//                       fit: BoxFit.cover,
//                       // scale: 2,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             ListTile(
//               title: const Text(
//                 "My Favourites",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text('PRIVATE . ${favProvider.favouriteItems.length} SONGS . ${favProvider.favouriteItems.length*30} SECS',
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.5),
//                   fontWeight: FontWeight.bold
//                 ),
//               ),
//
//               trailing: PlayRoundButton(items: favProvider.favouriteItems.values.toList()),
//
//             ),
//             Expanded(
//               flex: 4,
//               child: ListView.builder(key: ValueKey(favProvider.favouriteItems.length), itemCount: favProvider.favouriteItems.length, itemBuilder: (context, index)=>
//                   ListAllWidget(index: index,items: favProvider.favouriteItems.values.toList(growable: false), decorationReq: true,)),
//             ),
//           ],
//         )
//       ],
//     ))
// );