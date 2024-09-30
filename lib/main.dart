import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Views/album_view.dart';
import 'package:runo_music/Views/artist_view.dart';
import 'package:runo_music/Views/genre_view.dart';
import 'package:runo_music/Views/login_view.dart';
import 'package:runo_music/Views/music_player_view.dart';
import 'package:runo_music/Views/profile_view.dart';
import 'package:runo_music/tab_screen.dart';
import 'Services/Providers/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Views/search.dart';
import 'firebase_options.dart';

var kDarkTheme = ColorScheme(
    brightness: Brightness.dark,
    primary: const Color.fromARGB(255, 18, 20, 25),
    onPrimary: Colors.white,
    secondary: Colors.grey.withOpacity(0.1),
    onSecondary: Colors.grey,
    tertiary: const Color.fromARGB(255, 37, 209, 218),
    error: Colors.red,
    onError: Colors.white,
    surface: const Color.fromARGB(255, 44, 54, 62),
    onSurface: Colors.white);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavouriteItemsProvider()),
        ChangeNotifierProvider(create: (context) => AudioProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/tab-screen',
        builder: (context, state) => TabScreen(),
      ),
      GoRoute(
        path: '/music-player',
        builder: (context, state) => const MusicPlayerView(),
      ),
      GoRoute(
        path: '/album/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final extra = state.extra as Map<String, dynamic>;
          final items = extra['items'] as List<dynamic>;
          final index = extra['index'] as int;
          return TabScreen(
            activePage: AlbumView(items: items, index: index),
          );
        },
      ),
      GoRoute(
        path: '/artist/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TabScreen(
            activePage: ArtistView(artistId: id),
          );
        },
      ),
      GoRoute(
        path: '/genre-view',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final genreData = extra['genreData'] as List<dynamic>;
          final gradientColors = extra['gradientColors'] as List<Color>;
          return TabScreen(
            activePage: GenreView(genreData: genreData, gradientColors: gradientColors),
          );
        },
      ),
      GoRoute(
        path: '/profile-view',
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const Search(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData().copyWith(colorScheme: kDarkTheme),
      routerConfig: _router,
    );
  }
}

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   return runApp(
//       MultiProvider(
//           providers: [
//             ChangeNotifierProvider(create: (context)=>FavouriteItemsProvider()),
//             ChangeNotifierProvider(create: (context)=>AudioProvider())
//           ],
//         child:MaterialApp(
//           debugShowCheckedModeBanner: false,
//             home: LoginView(),
//           themeMode: ThemeMode.dark,
//           darkTheme: ThemeData().copyWith(
//             colorScheme: kDarkTheme)
//         )) ,
//       ) ;
// }






// home: StreamBuilder(
//     stream: FirebaseAuth.instance.authStateChanges(),
//     builder: (context, snapshot){
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return CircularProgressIndicator();
//       }
//       else if(snapshot.hasData)
//         {
//           return TabScreen();
//         }
//       return LoginView();
//     }
// ),