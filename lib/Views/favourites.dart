import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Views/music_player_view.dart';

import '../Helper/deviceParams.dart';

import '../Widgets/list_all.dart';
import '../Widgets/back_ground_blur.dart';
import '../Widgets/provider.dart';

class Favourites extends StatefulWidget {

  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  String Fav_img =
      "https://m.media-amazon.com/images/G/01/ctt2309d82309/2022_en_US-UK-CA-AUNZ_MySoundtrack_PG_GH_2400x2400._UXNaN_FMjpg_QL85_.jpg";
  @override
  Widget build(BuildContext context) {

    return Consumer2<FavouriteItemsProvider, AudioProvider>(builder: (context, favProvider,audioProvider, child)=>Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        leading:
        IconButton(
            onPressed: (){
              // Navigator.pop(context);
            },
            icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white,size: 40,)
        ),
        backgroundColor: Colors.white.withOpacity(0.0001),
        actions: [IconButton(
            onPressed: (){
              // Navigator.pop(context);
            },
            icon:const Icon(Icons.more_vert, color: Colors.white,size: 25,)
        ),],
      ),
        backgroundColor: const Color.fromARGB(200, 88, 86, 86),
        body: Stack(
          children: [
            Image.network(
              Fav_img,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            const BackGroundBlur(),
            Container(
              margin: EdgeInsets.only(top: getHeight(context)/3),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.black.withOpacity(0.01),
                        Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.9)
                  ])),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: SizedBox(
                      height: 250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          Fav_img,
                          fit: BoxFit.cover,
                          // scale: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text(
                    "My Favourites",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('PRIVATE . ${favProvider.favouriteItems.length} SONGS . ${favProvider.favouriteItems.length*30} SECS',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  trailing:Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color.fromARGB(255, 12, 189, 189)
                    ),
                    child: IconButton(onPressed: () async{

                      if(favProvider.favouriteItems.isEmpty)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor:Colors.orangeAccent, content: Text("Please Add Some Songs To Play", style: TextStyle(color: Colors.white),)));
                        }
                      else
                        {
                          await audioProvider.loadAudio(trackList: favProvider.favouriteItems.values.toList(), index: 0);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MusicPlayerView()),);
                        }

                    }, icon: const Icon(Icons.play_arrow, size: 30,)),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ListView.builder(key: ValueKey(favProvider.favouriteItems.length), itemCount: favProvider.favouriteItems.length, itemBuilder: (context, index)=>
                      ListAllWidget(index: index,items: favProvider.favouriteItems.values.toList(growable: false), decorationReq: true,)),
                ),
              ],
            )
          ],
        ))
    );
  }
}
