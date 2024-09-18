import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Views/music_player_view.dart';
import '../Views/favourites.dart';
import '../Views/search.dart';
import '../Views/mini_player_view.dart';

import '../Helper/deviceParams.dart';
import '../Helper/Responsive.dart';

import '../Widgets/search_bar.dart';
import '../Widgets/provider.dart';

import '../home.dart';


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
    Widget activePage = const Home();
    if (selectedIndex == 0) {
      setState(() {
        activePage = const Home();
        title = "Explore Music";
      });
    }
    else if (selectedIndex == 1) {
      setState(() {
        if(Responsive.isLargeScreen(context))
        {
          activePage = const Favourites();
        }
        else
        {
          activePage = const Search();
        }
      });
    }
    else if (selectedIndex == 2) {
      setState(() {
          activePage = const Favourites();
      });
    }

    return Scaffold(

        backgroundColor: const Color.fromARGB(255, 18, 20, 25),
    
        body: (Responsive.isSmallScreen(context))
            ? activePage
            : Stack(
                children: [

                  Column(
                    children: [
                      const SizedBox(height: 72,), //To match with the tab bar height
                      Expanded(child: activePage)
                    ],
                  ),

                  // top nav bar for medium and large screens
                  Container(
                      color: Colors.black87,
                      width: double.infinity,
                      height: 72,
                      child: Responsive.isMediumScreen(context)
                          ?
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.only(left:40),
                                    child: Text("runo music",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 25)),
                                  ),
                                ),
                                // SizedBox(width: getWidth(context)/5,),
                                Expanded(
                                  flex: 2,
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
                                )
                              ],
                            )
                          : //Large screen
                          Row(
                              children: [
                                 SizedBox(
                                  width: 550,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                      const Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 60),
                                              child: Text("runo music",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w200,
                                                      fontSize: 25)),
                                            )
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: BottomNavigationBar(
                                            backgroundColor: Colors.black87,
                                            landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
                                            onTap: _selectIndex,
                                            unselectedFontSize: 15,
                                            selectedFontSize: 15,
                                            selectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                            unselectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                            unselectedItemColor: Colors.white,
                                            selectedItemColor: const Color.fromARGB(255, 12, 189, 189),
                                            currentIndex: selectedIndex,
                                            items: [
                                              bottomNavItems(iconSize: 30)[0],
                                              bottomNavItems(iconSize: 30)[2]
                                            ],
                                          ),
                                        ),
                                    ]
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: searchBar(
                                      onSubmit: (val) {Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search(queryHomePage: val)));},
                                      height: 35,
                                      isMarginReq: false,
                                      width: getWidth(context) / 4,
                                    )),
                              ],
                            )
                  ),
                ],
              ),
        bottomNavigationBar: (Responsive.isSmallScreen(context) || (audioProvider.openMiniPlayer)) ?
        Container(
          alignment: Alignment.bottomCenter,
          height: (Responsive.isSmallScreen(context) && !audioProvider.openMiniPlayer) ? 50 :(Responsive.isSmallScreen(context) && audioProvider.openMiniPlayer ? 120 : (Responsive.isMediumScreen(context)?60:80)) ,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:  [
                const Color.fromARGB(255, 51, 62, 71).withOpacity(0.01),
                const  Color.fromARGB(255, 51, 62, 71).withOpacity(0.1),
                Colors.black87.withOpacity(0.5)
              ])),
          child: Container(
            margin: Responsive.isSmallScreen(context)? const EdgeInsets.symmetric(horizontal: 10):null,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 44, 54, 62),
                borderRadius: BorderRadius.circular(10)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
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
                  if (Responsive.isSmallScreen(context))
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
        ):null
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
          Icons.person_2_outlined,
          size: iconSize,
        ),
        activeIcon: Icon(
          Icons.person,
          size: iconSize,
        ),
        label: "LIBRARY"),
  ];
}
