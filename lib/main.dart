import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Views/login_view.dart';

import '../tab_screen.dart';
import '../Widgets/provider.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

var kDarkTheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromARGB(255, 18, 20, 25),
    onPrimary: Colors.white,
    secondary: Colors.grey.withOpacity(0.1),
    onSecondary: Colors.grey,
    tertiary: Color.fromARGB(255, 37,209,218) ,
    error: Colors.red,
    onError: Colors.white,
    surface: Color.fromARGB(255, 44, 54, 62),
    onSurface: Colors.white);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context)=>FavouriteItemsProvider()),
            ChangeNotifierProvider(create: (context)=>AudioProvider())
          ],
        child:MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoginView(),
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData().copyWith(
            colorScheme: kDarkTheme)
        )) ,
      ) ;
}
