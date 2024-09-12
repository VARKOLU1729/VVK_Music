import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Views/music_player_view.dart';
import 'package:runo_music/Helper/deviceParams.dart';
import 'package:runo_music/Widgets/search_bar.dart';
import 'package:runo_music/home.dart';
import 'package:runo_music/Views/favourites.dart';
import 'Widgets/favourite_items_provider.dart';
import 'Widgets/mini_player_view.dart';
import 'Views/search.dart';
import 'Helper/Responsive.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

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
    var audioProvider = Provider.of<AudioProvider>(context);
    Widget activePage = Home();
    if (selectedIndex == 0) {
      setState(() {
        activePage = Home();
        title = "Explore Music";
      });
    }
    if (selectedIndex == 1) {
      setState(() {
        if(Responsive().isLargeScreen(context))
        {
          activePage = Favourites();
        }
        else
        {
          activePage = Search();
        }
      });
    }
    if (selectedIndex == 2) {
      setState(() {
          activePage = Favourites();
      });
    }

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 18, 20, 25),
    
        body: (Responsive().isSmallScreen(context))
            ? activePage
            : Stack(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 72,),
                      Expanded(child: activePage)
                    ],
                  ),
                  Container(
                      color: Colors.black87,
                      width: double.infinity,
                      height: 72,
                      child: Responsive().isMediumScreen(context)
                          ?
                          // Text("HI", style: TextStyle(color: Colors.white)
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 40),
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
                                        // elevation: 100,
                                        unselectedItemColor: Colors.white70,
                                        selectedItemColor:
                                            Color.fromARGB(255, 12, 189, 189),
                                        currentIndex: selectedIndex,
                                        items: bottomNavItems(iconSize: 25)),
                                  ),
                                )
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 550,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 40),
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
                                            selectedLabelStyle:TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                            unselectedLabelStyle:TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                            unselectedItemColor: Colors.white,
                                            selectedItemColor:
                                                Color.fromARGB(255, 12, 189, 189),
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
                                Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: searchBar(
                                      onSubmit: (val) {Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search(queryHomePage: val)));},
                                      height: 35,
                                      isMarginReq: false,
                                      width: getWidth(context) / 4,
                                    )),
                              ],
                            )),
                ],
              ),
        bottomNavigationBar: Container(
          alignment: Alignment.bottomCenter,
          height: audioProvider.openMiniPlayer && Responsive().isSmallScreen(context) ? 130 : 60,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromARGB(255, 51, 62, 71).withOpacity(0.1),
                Color.fromARGB(255, 51, 62, 71).withOpacity(0.5)
              ])),
          child: Container(
            color: Color.fromARGB(255, 44, 54, 62),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (audioProvider.openMiniPlayer == true)
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MusicPlayerView()));
                        },
                        child: MiniPlayerView(),
                      ),
                    ),
                  if (Responsive().isSmallScreen(context))
                    Expanded(
                      flex: 1,
                      child: BottomNavigationBar(
                          onTap: _selectIndex,
                          selectedLabelStyle:
                          TextStyle(color: Colors.white, fontSize: 10),
                          unselectedLabelStyle:
                          TextStyle(color: Colors.white, fontSize: 10),
                          // elevation: 100,
                          backgroundColor: Color.fromARGB(255, 44, 54, 62),
                          unselectedItemColor: Colors.white70,
                          selectedItemColor: Color.fromARGB(255, 12, 189, 189),
                          currentIndex: selectedIndex,
                          items: bottomNavItems(iconSize: 20)),
                    ),
                ],
              ),
            ),
          ),
        ));
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
