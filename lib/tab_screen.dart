import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Views/profile_view.dart';
import 'package:runo_music/Widgets/nav_bar.dart';

import '../Views/music_player_view.dart';
import '../Views/search.dart';
import '../Views/mini_player_view.dart';

import '../Helper/deviceParams.dart';
import '../Helper/Responsive.dart';

import '../Widgets/search_bar.dart';
import 'Services/Providers/provider.dart';

import '../home.dart';

import 'dart:math' as math;

import 'Views/library.dart';

class TabScreen extends StatefulWidget {

  Widget? activePage;
  bool showAppBar;
  TabScreen({super.key, this.activePage, this.showAppBar=true});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {

  int selectedIndex = 0;

  String title = "RUNO MUSIC";

  void _selectIndex(index) {
    setState(() {
      selectedIndex = index;
      widget.activePage = null;
    });
  }


  @override
  Widget build(BuildContext context) {

    AudioProvider audioProvider = Provider.of<AudioProvider>(context);

    List<Widget> tabs = [
      const Home(),
      Responsive.isLargeScreen(context) || Responsive.isMediumScreen(context) ? const Library() : const Search(),
      // const Favourites(),
      Library()
    ];

    Widget activePage = tabs[selectedIndex];


    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: const Color.fromARGB(255, 18, 20, 25),
        //appBar for desktop
        appBar: !Responsive.isMobile() ? (widget.showAppBar==true ? AppBar(
          toolbarHeight: 72,
          bottom: PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 0,thickness: 0,color: Colors.grey,)),
          backgroundColor: Colors.black.withOpacity(0.5),
          actions: [
            if(Responsive.isSmallScreen(context))
            CustomNavBar(
              width: 250,
              backgroundColor: Colors.transparent,
              selectedIndex: selectedIndex,
              onTap: _selectIndex,
              showLabel: false,
              selectedItemColor: Colors.tealAccent,
              unselectedItemColor: Colors.white,
              selectedFontSize: 14,
              unselectedFontSize: 12,
              items: [
                customNavItems()[0],
                customNavItems()[1],
                customNavItems()[2]
              ],
            ),
            if(Responsive.isMediumScreen(context) || Responsive.isLargeScreen(context))
              NavSearchBar(),
            ProfileButton()
          ],
          leadingWidth: getWidth(context)<850 ? 300 : 400,
          leading: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Runo Music",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w200,
                          fontSize: getWidth(context)<850 ? 20 : 25)),
                ),
              ),
              if(Responsive.isLargeScreen(context) || Responsive.isMediumScreen(context))
                Expanded(
                  flex: 3,
                  child: CustomNavBar(
                    width: 300,
                    backgroundColor: Colors.transparent,
                    selectedIndex: selectedIndex,
                    onTap: _selectIndex,
                    showLabel: Responsive.isMediumScreen(context) ? false :true,
                    selectedItemColor: Colors.tealAccent,
                    unselectedItemColor: Colors.white,
                    selectedFontSize: 14,
                    unselectedFontSize: 12,
                    labelStyle: Responsive.isLargeScreen(context) ? const TextStyle(fontSize: 15, fontWeight: FontWeight.w600) : null,
                    items: [
                      customNavItems()[0],
                      customNavItems()[2]
                    ],
                  ),
                ),
            ],
          )
          ):null):null,

        body:widget.activePage!=null ? widget.activePage! : activePage,
      
      bottomNavigationBar: (Responsive.isMobile(context) || (audioProvider.openMiniPlayer)) ?
        Container(
          alignment: Alignment.bottomCenter,
          height: (Responsive.isMobile(context) && !audioProvider.openMiniPlayer) ? 55 :(Responsive.isMobile(context) && audioProvider.openMiniPlayer ? 125 : (Responsive.isMediumScreen(context)||Responsive.isSmallScreen(context)?80:80)) ,
          decoration: Responsive.isMobile()? BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:  [
                    Color.fromARGB(255, 29, 33, 33).withOpacity(0.5) ,
                    Color.fromARGB(255, 29, 33, 33).withOpacity(0.5) ,
                    Color.fromARGB(255, 29, 33, 33) ,
                    Color.fromARGB(255, 29, 33, 33) ,
                Colors.black87
              ])):null,
          child: Container(
            margin: Responsive.isMobile(context)? const EdgeInsets.symmetric(horizontal: 10):null,
            decoration: BoxDecoration(
              color:Responsive.isMobile() ? const Color.fromARGB(255, 29, 33, 33) : Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(audioProvider.openMiniPlayer == true)
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 2,
                      trackShape:const RectangularSliderTrackShape(),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: Responsive.isMobile(context)?1:3),
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: Responsive.isMobile(context)?1:3),
                    ),
                    child: Padding(
                      padding: Responsive.isMobile(context) ? const EdgeInsets.symmetric(horizontal: 5) : const EdgeInsets.all(0),
                      child: Slider(
                        allowedInteraction: SliderInteraction.tapAndSlide,
                        thumbColor: Responsive.isMobile(context) ? const Color.fromARGB(255, 29, 33, 33) : Colors.white,
                        activeColor: Responsive.isMobile(context) ? Colors.grey : Colors.white,
                        inactiveColor: Responsive.isMobile(context) ? const Color.fromARGB(255, 29, 33, 33) : Colors.grey,
                        value: audioProvider.currentPosition.inSeconds.toDouble(),
                        min: 0.0,
                        max: audioProvider.duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          // audioProvider.seekTo(value);
                          audioProvider.seekTo(value.round());
                        },
                      ),
                    ),
                  ),

                  if (audioProvider.openMiniPlayer == true)
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MusicPlayerView()));
                          context.push('/music-player');
                        },
                        child: const MiniPlayerView(),
                      ),
                    ),
                  if (Responsive.isMobile(context))
                    Expanded(
                      flex: 1,
                      child: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                          onTap: _selectIndex,
                          selectedLabelStyle: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                          unselectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                          backgroundColor: const Color.fromARGB(255, 29, 33, 33) ,
                          unselectedItemColor: Colors.white70,
                          selectedItemColor: Theme.of(context).colorScheme.tertiary,
                          currentIndex: selectedIndex,
                          items: bottomNavItems(iconSize: 25.0)),
                    ),
                ],
              ),
            ),
          ),
        ):null


    );
  }
}

class NavSearchBar extends StatelessWidget {
  NavSearchBar({super.key});
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            mouseCursor: MouseCursor.defer,
            onTap:  () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => TabScreen(showAppBar:false, activePage: Search(),) ));
              context.push('/search');
              },
            child: searchBar(
              enabled: false,
              // textController: _searchController,
              // onSubmit: (val) {Navigator.of(context).push(MaterialPageRoute(builder: (context) => TabScreen(showAppBar:false, activePage: Search(queryHomePage: val,))));},
              height: 35,
              isMarginReq: false,
              width: 300,
            ),
          )),
    );
  }
}


class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: Responsive.isMediumScreen(context)?20:(Responsive.isLargeScreen(context)?40:10)),
      child: IconButton(
        tooltip: "Profile",
        onPressed: (){
          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TabScreen(activePage: ProfileView(),)));
          context.push('/profile-view');
          },
        icon: const Icon(Icons.person),
        color: Colors.white,
        hoverColor: Colors.grey.withOpacity(0.4),
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.4))
        ),
      ),
    );
  }
}



List<BottomNavigationBarItem> bottomNavItems({required iconSize}) {
  return [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.home_outlined,
          size: iconSize,
        ),
        activeIcon: Icon(
          Icons.home_filled,
          size: iconSize,
        ),
        label: "HOME"),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.search,
          size: iconSize,
        ),
        label: "FIND"),
    // BottomNavigationBarItem(
    //     icon: Icon(
    //       Icons.favorite_border,
    //       size: iconSize,
    //     ),
    //     activeIcon: Icon(
    //       Icons.favorite,
    //       size: iconSize,
    //     ),
    //     label: "FAVOURITES"),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.library_music_outlined,
          size: iconSize,
        ),
        activeIcon: Icon(
          Icons.library_music,
          size: iconSize,
        ),
        label: "LIBRARY"),
  ];
}

List<CustomNavBarItem> customNavItems() {
  return [
    CustomNavBarItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_filled,
        label: "HOME"),
    CustomNavBarItem(
      icon:Icons.search,
        activeIcon: Icons.search,
        label: "SEARCH"),
    CustomNavBarItem(
        icon:  Icons.library_music_outlined,
        activeIcon: Icons.library_music,
        label: "LIBRARY"),
  ];
}
