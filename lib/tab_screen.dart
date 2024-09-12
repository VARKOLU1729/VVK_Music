import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Views/music_player_view.dart';
import 'package:runo_music/home.dart';
import 'package:runo_music/Views/favourites.dart';
import 'Widgets/favourite_items_provider.dart';
import 'Widgets/mini_player_view.dart';
import 'Views/search.dart';

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
    if (selectedIndex== 0) {
      setState(() {
        selectedIndex = 0;
        activePage = Home();
        title = "Explore Music";
      });
    }
    if(selectedIndex==1)
      {
        setState(() {
          selectedIndex=1;
          activePage = Search();
        });
      }
    if (selectedIndex == 2) {
      setState(() {
        selectedIndex = 2;
        activePage = Favourites();
        title = "Your Library";
      });
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 20, 25),
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 1,
      ),

      body:activePage,
      bottomNavigationBar:
          Container(
            alignment: Alignment.bottomCenter,
            height: audioProvider.openMiniPlayer ? 130 : 60,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color.fromARGB(255, 51, 62, 71).withOpacity(0.1), Color.fromARGB(255, 51, 62, 71).withOpacity(0.5)])
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(audioProvider.openMiniPlayer==true)
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 90,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    color: Color.fromARGB(255, 44, 54, 62),
                    child: InkWell(
                      onTap:(){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MusicPlayerView()));
                      } ,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: MiniPlayerView()),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      // borderRadius: BorderRadius.circular(20),
                      child: BottomNavigationBar(
                        onTap: _selectIndex,
                        // elevation: 100,
                        backgroundColor:   Color.fromARGB(255, 44, 54, 62),
                        unselectedItemColor: Colors.white70,
                        selectedItemColor: Color.fromARGB(255, 12, 189, 189),
                        currentIndex: selectedIndex,
                        items: [
                          BottomNavigationBarItem(icon: Icon(Icons.home_outlined, size: 20,),activeIcon:Icon(Icons.home_filled, size: 20,) , label: "HOME"),
                          BottomNavigationBarItem(icon: Icon(Icons.search), label: "SEARCH"),
                          BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined, size: 20,), activeIcon: Icon(Icons.person, size: 20,),label: "LIBRARY"),
                          // BottomNavigationBarItem(icon: Icon(Icons.adjust_rounded), label: "SEARCH"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )



    );
  }
}
