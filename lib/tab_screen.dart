import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Widgets/nav_bar.dart';

import '../Views/music_player_view.dart';
import '../Views/favourites.dart';
import '../Views/search.dart';
import '../Views/mini_player_view.dart';

import '../Helper/deviceParams.dart';
import '../Helper/Responsive.dart';

import '../Widgets/search_bar.dart';
import '../Widgets/provider.dart';

import '../home.dart';

import 'dart:math' as math;

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {

  int selectedIndex = 0;

  String title = "RUNO MUSIC";

  void _selectIndex(index) {
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {

    AudioProvider audioProvider = Provider.of<AudioProvider>(context);

    List<Widget> tabs = [
      const Home(),
      Responsive.isLargeScreen(context) || Responsive.isMediumScreen(context) ? const Favourites() : const Search(),
      const Favourites()
    ];

    Widget activePage = tabs[selectedIndex];


    return Scaffold(

        backgroundColor: const Color.fromARGB(255, 18, 20, 25),
    
        body:  Stack(
                children: [
                  NestedScrollView(
                      headerSliverBuilder: (context, val){
                        return [SliverToBoxAdapter(
                          child:SizedBox(height:Responsive.isMobile(context)?1: 72,),
                        )];
                      },
                      body: activePage
                  ),

                  // top nav bar for web
                  if(!Responsive.isMobile(context))
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          color: Colors.black87,
                          width: double.infinity,
                          height: 72,
                          child: (Responsive.isSmallScreen(context))
                              ?
                              Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      child: Padding(
                                        padding: EdgeInsets.only(left:20),
                                        child: Text("Runo Music",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w200,
                                                fontSize: 15)),
                                      ),
                                    ),
                                    // SizedBox(width: getWidth(context)/5,),
                                    const Spacer(),
                                    SizedBox(
                                      width: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: BottomNavigationBar(
                                            showUnselectedLabels: false,
                                            showSelectedLabels: false,
                                            backgroundColor: Colors.black87,
                                            onTap: _selectIndex,
                                            unselectedItemColor: Colors.white70,
                                            selectedItemColor: const Color.fromARGB(255, 12, 189, 189),
                                            currentIndex: selectedIndex,
                                            items: bottomNavItems(iconSize: 25)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: IconButton(
                                        tooltip: "Profile",
                                        onPressed: (){},
                                        icon: const Icon(Icons.person_rounded),
                                        color: Colors.white,
                                        hoverColor: Colors.grey.withOpacity(0.4),
                                        style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.4))
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              :
                             (Responsive.isMediumScreen(context)?
                              TopNavBar(width: getWidth(context)<850 ? 300 : 400, selectedIndex: selectedIndex, selectIndex: _selectIndex, titleTextSize: getWidth(context)<850 ? 20 : 25,
                                navItems: CustomNavBar(
                                    selectedIndex: selectedIndex,
                                    onTap: _selectIndex,
                                    showLabel: false,
                                    selectedItemColor: Colors.tealAccent,
                                    unselectedItemColor: Colors.white,
                                    selectedFontSize: 14,
                                    unselectedFontSize: 12,
                                    items: [
                                      customNavItems()[0],
                                      customNavItems()[2]
                                    ],
                                ),
                              )://largeScreen
                             TopNavBar(width: 450, selectedIndex: selectedIndex, selectIndex: _selectIndex, titleTextSize: 25,
                              navItems: CustomNavBar(
                                  selectedIndex: selectedIndex,
                                  onTap: _selectIndex,
                                  showLabel: true,
                                  labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                  selectedItemColor: Colors.tealAccent,
                                  unselectedItemColor: Colors.white,
                                  selectedFontSize: 15,
                                  unselectedFontSize: 15,
                                  items: [
                                    customNavItems()[0],
                                    customNavItems()[2]
                                 ],
                              ),
                             )
                      )
                      ),
                      const Divider(height: 0, thickness: 0,)
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: (Responsive.isMobile(context) || (audioProvider.openMiniPlayer)) ?
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: (Responsive.isMobile(context) && !audioProvider.openMiniPlayer) ? 50 :(Responsive.isMobile(context) && audioProvider.openMiniPlayer ? 120 : (Responsive.isSmallScreen(context)?65:85)) ,
                      decoration: Responsive.isMobile(context)? BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors:  [
                                const Color.fromARGB(255, 51, 62, 71).withOpacity(0.01),
                                const  Color.fromARGB(255, 51, 62, 71).withOpacity(0.1),
                                Colors.black87.withOpacity(0.5)
                              ])):null,
                      child: Container(
                        margin: Responsive.isMobile(context)? const EdgeInsets.symmetric(horizontal: 10):null,
                        decoration: BoxDecoration(
                            color: Responsive.isMobile(context) ? const Color.fromARGB(255, 44, 54, 62) : Colors.black.withOpacity(0.9),
                            borderRadius:  Responsive.isMobile(context) ?  BorderRadius.circular(10) : BorderRadius.zero
                        ),
                        child: ClipRRect(
                          borderRadius:  Responsive.isMobile(context) ?  BorderRadius.circular(10) : BorderRadius.zero,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (audioProvider.openMiniPlayer == true)
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => const MusicPlayerView()));
                                    },
                                    child: const MiniPlayerView(),
                                  ),
                                ),
                              if (Responsive.isMobile(context))
                                Expanded(
                                  flex: 1,
                                  child: BottomNavigationBar(
                                      onTap: _selectIndex,
                                      selectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 10),
                                      unselectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 10),
                                      backgroundColor: const Color.fromARGB(255, 44, 54, 62),
                                      unselectedItemColor: Colors.white70,
                                      selectedItemColor: const Color.fromARGB(255, 12, 189, 189),
                                      currentIndex: selectedIndex,
                                      items: bottomNavItems(iconSize: 20.0)),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ):const Text("Hi", style: TextStyle(color: Colors.black),)
                  ),
                  if(audioProvider.openMiniPlayer)
                  Positioned(
                    bottom: Responsive.isMobile(context)  ? 112 : (Responsive.isSmallScreen(context)?57:77),
                    left: 0,
                    right: 0,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 3,
                        trackShape:const RectangularSliderTrackShape(),
                        overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 6),
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: Responsive.isMobile(context)?3:5),
                      ),
                      child: Padding(
                        padding: Responsive.isMobile(context) ? const EdgeInsets.symmetric(horizontal: 10) : const EdgeInsets.all(0),
                        child: Slider(
                          allowedInteraction:
                          SliderInteraction.tapAndSlide,
                          thumbColor: Responsive.isMobile(context) ? const Color.fromARGB(255, 44, 54, 62) : Colors.white,
                          activeColor: Responsive.isMobile(context) ? Colors.grey : Colors.white,
                          inactiveColor: Responsive.isMobile(context) ? const Color.fromARGB(255, 44, 54, 62) : Colors.grey,
                          value: audioProvider.duration.inMilliseconds > 0
                              ? math.min(audioProvider.currentPosition.inMilliseconds /
                              audioProvider.duration.inMilliseconds,1)
                              : 0.0,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) {
                            audioProvider.seekTo(value);
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
        // bottomNavigationBar: (Responsive.isMobile(context) || (audioProvider.openMiniPlayer)) ?
        // Container(
        //   alignment: Alignment.bottomCenter,
        //   height: (Responsive.isMobile(context) && !audioProvider.openMiniPlayer) ? 50 :(Responsive.isMobile(context) && audioProvider.openMiniPlayer ? 120 : (Responsive.isMediumScreen(context)||Responsive.isSmallScreen(context)?60:80)) ,
        //   decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //           begin: Alignment.topCenter,
        //           end: Alignment.bottomCenter,
        //           colors:  [
        //         const Color.fromARGB(255, 51, 62, 71).withOpacity(0.01),
        //         const  Color.fromARGB(255, 51, 62, 71).withOpacity(0.1),
        //         Colors.black87.withOpacity(0.5)
        //       ])),
        //   child: Container(
        //     margin: Responsive.isMobile(context)? const EdgeInsets.symmetric(horizontal: 10):null,
        //     decoration: BoxDecoration(
        //       color: const Color.fromARGB(255, 44, 54, 62),
        //         borderRadius: BorderRadius.circular(10)
        //     ),
        //     child: ClipRRect(
        //       borderRadius: BorderRadius.circular(10),
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           if (audioProvider.openMiniPlayer == true)
        //             Expanded(
        //               flex: 1,
        //               child: InkWell(
        //                 onTap: () {
        //                   Navigator.of(context).push(MaterialPageRoute(
        //                       builder: (context) => const MusicPlayerView()));
        //                 },
        //                 child: const MiniPlayerView(),
        //               ),
        //             ),
        //           if (Responsive.isMobile(context))
        //             Expanded(
        //               flex: 1,
        //               child: BottomNavigationBar(
        //                   onTap: _selectIndex,
        //                   selectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 10),
        //                   unselectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 10),
        //                   backgroundColor: const Color.fromARGB(255, 44, 54, 62),
        //                   unselectedItemColor: Colors.white70,
        //                   selectedItemColor: const Color.fromARGB(255, 12, 189, 189),
        //                   currentIndex: selectedIndex,
        //                   items: bottomNavItems(iconSize: 20.0)),
        //             ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ):null
    );
  }
}

class TopNavBar extends StatelessWidget {
  final void Function(int) selectIndex;
  final int selectedIndex;
  final double titleTextSize;
  final Widget navItems;
  final double width;
  const TopNavBar({super.key,required this.width, required this.selectedIndex, required this.selectIndex, required this.titleTextSize, required this.navItems});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: width,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text("Runo Music",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              fontSize: titleTextSize)),
                    )
                ),
                Expanded(
                  flex: 3,
                  child: navItems
                ),
              ]
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 250,
          child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                mouseCursor: MouseCursor.defer,
                onTap:  () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Search()));},
                child: const searchBar(
                  enabled: false,
                  // onSubmit: (val) {Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search(queryHomePage: val)));},
                  height: 35,
                  isMarginReq: false,
                  width: 300,
                ),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(right: Responsive.isMediumScreen(context)?20:(Responsive.isLargeScreen(context)?40:10)),
          child: IconButton(
            tooltip: "Profile",
              onPressed: (){},
              icon: const Icon(Icons.person),
              color: Colors.white,
            hoverColor: Colors.grey.withOpacity(0.4),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.4))
              ),
          ),
        )
      ],
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
        label: "SEARCH"),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.favorite_border,
          size: iconSize,
        ),
        activeIcon: Icon(
          Icons.favorite,
          size: iconSize,
        ),
        label: "FAVOURITES"),
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
        icon: Icons.favorite_border,
        activeIcon: Icons.favorite,
        label: "LIBRARY"),
  ];
}
