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
    
        body: (Responsive.isMobile(context))
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
                      child: (Responsive.isSmallScreen(context))
                          ?
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
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
                                Spacer(),
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
                                    icon: Icon(Icons.person_rounded),
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
                          topNavBar(width: getWidth(context)<850 ? 300 : 400, selectedIndex: selectedIndex, selectIndex: _selectIndex, titleTextSize: getWidth(context)<850 ? 20 : 25,
                            navItems: BottomNavigationBar(
                              backgroundColor: Colors.black87,
                              onTap: _selectIndex,
                              showSelectedLabels: false,
                              showUnselectedLabels: false,
                              unselectedItemColor: Colors.white,
                              selectedItemColor: const Color.fromARGB(255, 12, 189, 189),
                              currentIndex: selectedIndex,
                              items: [
                                bottomNavItems(iconSize: 30)[0],
                                bottomNavItems(iconSize: 30)[2]
                                ],
                              ),
                          )://largeScreen
                         topNavBar(width: 450, selectedIndex: selectedIndex, selectIndex: _selectIndex, titleTextSize: 25,
                           navItems: BottomNavigationBar(
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
                         )
                  )
                  )
                ],
              ),
        bottomNavigationBar: (Responsive.isMobile(context) || (audioProvider.openMiniPlayer)) ?
        Container(
          alignment: Alignment.bottomCenter,
          height: (Responsive.isMobile(context) && !audioProvider.openMiniPlayer) ? 50 :(Responsive.isMobile(context) && audioProvider.openMiniPlayer ? 120 : (Responsive.isMediumScreen(context)||Responsive.isSmallScreen(context)?60:80)) ,
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
            margin: Responsive.isMobile(context)? const EdgeInsets.symmetric(horizontal: 10):null,
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
        ):null
    );
  }
}

class topNavBar extends StatelessWidget {
  final void Function(int) selectIndex;
  final int selectedIndex;
  final double titleTextSize;
  final Widget navItems;
  final double width;
  const topNavBar({super.key,required this.width, required this.selectedIndex, required this.selectIndex, required this.titleTextSize, required this.navItems});

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
                onTap:  () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search()));},
                child: searchBar(
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
              icon: Icon(Icons.person),
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
          Icons.favorite_outline,
          size: iconSize,
        ),
        activeIcon: Icon(
          Icons.favorite,
          size: iconSize,
        ),
        label: "FAVOURITES"),
  ];
}
//
// List<NavigationDestination> navItems({required iconSize}) {
//   return [
//     NavigationDestination(
//         icon: Icon(
//           Icons.home_outlined,
//           size: iconSize,
//         ),
//         selectedIcon: Icon(
//           Icons.home_filled,
//           size: iconSize,
//         ),
//         label: "HOME"),
//     NavigationDestination(
//         icon: Icon(
//           Icons.search,
//           size: iconSize,
//         ),
//         label: "SEARCH"),
//     NavigationDestination(
//         icon: Icon(
//           Icons.person_2_outlined,
//           size: iconSize,
//         ),
//         selectedIcon: Icon(
//           Icons.person,
//           size: iconSize,
//         ),
//         label: "LIBRARY"),
//   ];
// }
