import 'package:flutter/material.dart';
import 'package:runo_music/home.dart';
import 'package:runo_music/Views/favourites.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {

  int selectedIndex = 0;
  List<List<String>> favourites =[];
  void addToFavourites(List<String> item)
  {
    setState(() {
      favourites.add(item);
    });
  }

  String title = "RUNO MUSIC";
  void _selectIndex(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = Home(addToFavourites: addToFavourites);
    if (selectedIndex== 0) {
      setState(() {
        selectedIndex = 0;
        activePage = Home(addToFavourites: addToFavourites,);
        title = "RUNO";
      });
    }
    if (selectedIndex == 1) {
      setState(() {
        selectedIndex = 1;
        activePage = Favourites(favourites: favourites, addToFavourite:addToFavourites);
        title = "Favourites";
      });
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 20, 25),
      // appBar: AppBar(
      //   title: Text(title),
      //   backgroundColor: Colors.grey.withOpacity(0.1),
      // ),

      body:Stack(
        children: [
          activePage,
          Positioned(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Text("Explore Music",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                ),
              ),
              height: 70,
            ),
            // 
          )
        ],
      ),
      bottomNavigationBar:
          Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromARGB(255, 51, 62, 71).withOpacity(0.1), Color.fromARGB(255, 51, 62, 71).withOpacity(0.5)])
            ),
            child: Container(
              height: 60,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BottomNavigationBar(
                  onTap: _selectIndex,
                  // elevation: 100,
                  backgroundColor:   Color.fromARGB(255, 44, 54, 62),
                  unselectedItemColor: Colors.white70,
                  selectedItemColor: Color.fromARGB(255, 12, 189, 189),
                  currentIndex: selectedIndex,
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.home, size: 20,), label: "Home"),
                    // BottomNavigationBarItem(icon: ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.music_note, size: 20,), label: "My Music")
                  ],
                ),
              ),
            ),
          )


    );
  }
}
