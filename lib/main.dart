import 'package:flutter/material.dart';
import 'package:runo_music/tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Widgets/favourite_items_provider.dart';

var kColorTheme = ColorScheme(
    brightness: Brightness.light,
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Color.fromARGB(20, 20, 20, 20),
    onSecondary: Color.fromARGB(20, 20, 20, 20),
    error: Color.fromARGB(20, 20, 20, 20),
    onError: Color.fromARGB(20, 20, 20, 20),
    surface: Color.fromARGB(20, 20, 20, 20),
    onSurface: Color.fromARGB(20, 20, 20, 20));

var kDarkTheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromARGB(255, 18, 20, 25),
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 44, 54, 62),
    onSecondary: Colors.grey,
    error: Colors.red,
    onError: Color.fromARGB(20, 20, 20, 20),
    surface: Color.fromARGB(20, 20, 20, 20),
    onSurface: Color.fromARGB(20, 20, 20, 20));

void main() {
  return runApp(
      MultiProvider(providers: [ChangeNotifierProvider(create: (context)=>favouriteItemsProvider()),
        ChangeNotifierProvider(create: (context)=>AudioProvider())
      ],
        child:MaterialApp(
          debugShowCheckedModeBanner: false,
          home: TabScreen(),
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData().copyWith(
              primaryColor: Colors.black12,
              appBarTheme: AppBarTheme().copyWith(
                  backgroundColor: kDarkTheme.primary,
                  centerTitle: true,
                  titleTextStyle: TextStyle(color: kDarkTheme.onPrimary))),
          theme: ThemeData().copyWith(
              appBarTheme: AppBarTheme().copyWith(
                  backgroundColor: kColorTheme.primary,
                  centerTitle: true,
                  titleTextStyle: TextStyle(color: kColorTheme.onPrimary))),
        )) ,
      ) ;
}
