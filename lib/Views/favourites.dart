import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Widgets/list_all.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';
import 'package:runo_music/Widgets/back_ground_blur.dart';

import '../Widgets/favourite_items_provider.dart';

class Favourites extends StatefulWidget {
  Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  String Fav_img =
      "https://m.media-amazon.com/images/G/01/ctt2309d82309/2022_en_US-UK-CA-AUNZ_MySoundtrack_PG_GH_2400x2400._UXNaN_FMjpg_QL85_.jpg";
  @override
  Widget build(BuildContext context) {

    return Consumer<favouriteItemsProvider>(builder: (context, value, child)=>Scaffold(
        backgroundColor: Color.fromARGB(200, 88, 86, 86),
        body: Stack(
          children: [
            Image.network(
              Fav_img,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            BackGroundBlur(),
            Container(
              margin: EdgeInsets.only(top: 350),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.black.withOpacity(0.05),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.9)
                  ])),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          Fav_img,
                          fit: BoxFit.cover,
                          // scale: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "My Favourites",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(itemCount: value.favourite_items.length, itemBuilder: (context, index)=>
                      ListAllWidget(index: index,items: value.favourite_items.values.toList(growable: false))),
                ),
              ],
            )
          ],
        ))
    );
  }
}
