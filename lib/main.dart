import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tab_screen.dart';
import '../Widgets/provider.dart';

var kDarkTheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromARGB(255, 18, 20, 25),
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 44, 54, 62),
    onSecondary: Colors.grey,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.black87,
    onSurface: Colors.white);

void main() {
  return runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context)=>FavouriteItemsProvider()),
            ChangeNotifierProvider(create: (context)=>AudioProvider())
          ],
        child:MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const TabScreen(),
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData().copyWith(
              primaryColor: Colors.black12,
              appBarTheme: const AppBarTheme().copyWith(
                  backgroundColor: kDarkTheme.primary,
                  centerTitle: true,
                  titleTextStyle: TextStyle(color: kDarkTheme.onPrimary))),
        )) ,
      ) ;
}
