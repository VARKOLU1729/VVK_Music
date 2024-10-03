import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Views/same_view.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';

import '../Helper/Responsive.dart';
import '../Services/Providers/provider.dart';
import '../Widgets/mobile_app_bar2.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  
  @override
  Widget build(BuildContext context) {
    return Consumer2<FavouriteItemsProvider, AudioProvider>(builder: (context, favProvider,audioProvider, child)=>Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar:Responsive.isMobile() ? MobileAppBar2(context):null,
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 80,),

            if(Responsive.isMobile())
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading:  InkWell(
                mouseCursor: MouseCursor.uncontrolled,
                onTap: (){context.push('/profile-view');},
                child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile_image.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
              ),
              title: Text("My Library", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

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
    ));
  }
  
  Widget Header({required String title})
  {
    return Text("$title", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),);
  }

  Widget Item({required String Url, required String Title, required PageType pageType})
  {
    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 8,
              child: InkWell(
                onTap: (){ context.push('/same-view', extra: {'pageType':pageType}); },
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
