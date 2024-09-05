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
  List<List<String>> favourites = [];
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
        activePage = Favourites(favourites: favourites);
        title = "Favourites";
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(title),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectIndex,
        backgroundColor: Color(0xff01242b),
        unselectedItemColor: Colors.white70,
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          // BottomNavigationBarItem(icon: ),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note), label: "My Music")
        ],
      ),
    );
  }
}
