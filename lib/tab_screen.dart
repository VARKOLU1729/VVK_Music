import 'package:flutter/material.dart';
import 'package:runo_music/home.dart';
import 'package:runo_music/Views/favourites.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  Widget activePage = const Home();
  int selectedIndex = 0;
  String title = "RUNO MUSIC";
  void _selectScreen(index) {
    if (index == 0) {
      setState(() {
        selectedIndex = 0;
        activePage = Home();
        title = "RUNO";
      });
    }
    if (index == 1) {
      setState(() {
        selectedIndex = 1;
        activePage = Home();
        title = "Favourites";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(title),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectScreen,
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
