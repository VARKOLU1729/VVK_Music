import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:audioplayers/audioplayers.dart';
import 'package:runo_music/Helper/sort.dart';
import 'package:runo_music/models/play_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Helper/messenger.dart';
import '../Data/fetch_data.dart';
import '../../models/track_model.dart';
import 'dart:math';

String userUid = 'vMoTcvsOubUQl9QHqw0evli6TPT2';

void getUser() {
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      userUid =  FirebaseAuth.instance.currentUser!.uid;
    }
  });
}

Future<TrackModel?> getTrackData({required String trackId}) async {
  TrackModel? tracks;
  try {
    var trackDetailsJson = await fetchData(path: 'tracks/$trackId');
    var track = await TrackModel.fromJson(trackDetailsJson['tracks'][0]);
    tracks = track;
  } catch (error) {
    print(error);
  } finally {
    return tracks;
  }
}

class FavouriteItemsProvider extends ChangeNotifier {
  Map<String, TrackModel> favouriteItems = {};
  bool isLoading = true;

  FavouriteItemsProvider()
  {
    getUser();
  }

  void loadFavouriteItems() async
  {
    print("loadddddddd");
    isLoading = true;
    favouriteItems= {};
    final sp = await SharedPreferences.getInstance();
    List<String> items = [];
    if(sp.containsKey(userUid))
      {
        items = sp.getStringList(userUid)!;
      }
    else{
      sp.setStringList(userUid, []);
    }
    for (int i = 0; i < items.length; i++) {
      final track = await getTrackData(trackId: items[i]);
      favouriteItems[items[i]] = track!;
    }
    isLoading = false;
    notifyListeners();
  }

  void addToFavourite({required String id, required TrackModel details}) async {
    favouriteItems[id] = details;
    print("adding");
    final sp = await SharedPreferences.getInstance();
    if (sp.containsKey(userUid)) {
      List<String> value = sp.getStringList(userUid)!;
      value.add(id);
      sp.setStringList(userUid, value);
      print(value);
    }

    notifyListeners();
  }


  void sortFavourites(String sortBy) {
    print("sort");
    var sortedList = favouriteItems.values.toList();
    sortTracks(sortedList, sortBy: sortBy);
    favouriteItems = {
      for (var track in sortedList) track.id: track
    };

    notifyListeners();
  }

  void removeFromFavourite({required String id}) async {
    favouriteItems.remove(id);

    final sp = await SharedPreferences.getInstance();

    if (sp.containsKey(userUid)) {
      List<String> value = sp.getStringList(userUid)!;
      value.remove(id);
      sp.setStringList(userUid, value);
    }

    notifyListeners();
  }

  bool checkInFav({required String id}) {
    if (favouriteItems.containsKey(id)) return true;
    return false;
  }

  void toggleFavourite(
      {required String id,
      required TrackModel details,
      required BuildContext context}) {
    if (checkInFav(id: id)) {
      removeFromFavourite(id: id);
      showMessage(context: context, content: "Removed from fav's");

    } else {
      addToFavourite(id: id, details: details);
      showMessage(context: context, content: "Added to fav's");
    }
  }
}

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<dynamic> _items = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isLoop = false;
  bool _isLoading = false;
  double speed = 1;
  double _volume = 1.0;
  bool isShuffled = false;
  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;
  bool openMiniPlayer = false;
  List<int> shuffledIndices = []; //to keep track of indices that occured in shuffle loop
  List<TrackModel> recentPlayedItems = [];

  void setMiniPlayer() {
    openMiniPlayer = true;
    notifyListeners();
  }

  List<dynamic> get items => _items;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  bool get isLoop => _isLoop;
  bool get isLoading => _isLoading;
  double get volume => _volume;
  Duration get currentPosition => _currentPosition;
  Duration get duration => _duration;

  String? get trackId => _items.isNotEmpty ? _items[_currentIndex].id : null;
  String? get trackName =>
      _items.isNotEmpty ? _items[_currentIndex].name : null;
  String? get trackImageUrl =>
      _items.isNotEmpty ? _items[_currentIndex].imageUrl : null;
  String? get artistId =>
      _items.isNotEmpty ? _items[_currentIndex].artistId : null;
  String? get artistName =>
      _items.isNotEmpty ? _items[_currentIndex].artistName : null;
  String? get albumId =>
      _items.isNotEmpty ? _items[_currentIndex].albumId : null;
  String? get albumName =>
      _items.isNotEmpty ? _items[_currentIndex].albumName : null;

  AudioProvider() {
    _initializePlayer();
  }

  void _initializePlayer() {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((Duration d) {
      _duration = d;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      _currentPosition = p;
      notifyListeners();
    });


    _audioPlayer.onPlayerComplete.listen((event) async{
      if (_isLoop) {
        _playCurrentTrack();
      } else {
        nextTrack();
      }
      notifyListeners();
    });
  }

  void reset()
  {
    _currentPosition = Duration.zero;
    _audioPlayer.seek(Duration.zero);
    _audioPlayer.stop();
  }


  Future<void> loadAudio(
      {required List<dynamic> trackList, required int index}) async {
    _items = trackList;
    _currentIndex = index;
    _isLoading = true;
    notifyListeners();

    await _playCurrentTrack();
  }



  Future<void> _playCurrentTrack() async {
    if (_items.isEmpty) return;

    final track = _items[_currentIndex];
    final trackId = track.id;
    final urlData = await fetchData(path: 'tracks/$trackId');
    final previewUrl = urlData['tracks'][0]['previewURL'];

    //check if already exists in recent plays so as to push it to the top(by poping at earlier index and pushing again)
    for(int i=0; i<recentPlayedItems.length; i++)
      {
        if(recentPlayedItems[i].id==trackId) recentPlayedItems.removeAt(i);
      }
    recentPlayedItems.add(track);

    try {
      await _audioPlayer.setSourceUrl(previewUrl);
      await _audioPlayer.setVolume(_volume);
      await _audioPlayer.resume();
      _isPlaying = true;
    } catch (e) {
      print("Error playing audio: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void sortRecents(String sortBy) {
    var sortedList = recentPlayedItems;
    sortTracks(sortedList, sortBy: sortBy);
    recentPlayedItems = sortedList;
    notifyListeners();
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  int findRandIndex()
  {
    int x = 0;
    while(true)
      {
         x = Random().nextInt(items.length);
        if(x!=_currentIndex && (!shuffledIndices.contains(x)))
          {
            break;
          }
      }
      return x;
  }

  void toggleShuffle({required BuildContext context, List<dynamic>? itemsToShuffle})
  {
    if(itemsToShuffle!=null && !isShuffled)
      {
        List<dynamic> sItems = List.of(itemsToShuffle, growable: false);
        sItems.shuffle();
        loadAudio(trackList: sItems, index: 0);
      }
    isShuffled = !isShuffled;
    showMessage(context: context, content: isShuffled?"Shuffle on":"Shuffle off");
    notifyListeners();
  }


  void seekTo(int value) {
    // final newPosition = Duration(milliseconds: (_duration.inMilliseconds * value).round());
    final newPosition = Duration(seconds: value);
    _audioPlayer.seek(newPosition);
  }

  Future<void> nextTrack() async {
    if(_isLoop==false)
      {
        if (_currentIndex < _items.length - 1) {
          if(isShuffled)
          {
            _currentIndex = findRandIndex();
          }
          if(!isShuffled)
          {
            _currentIndex++;
          }
          if(_currentIndex >= _items.length) _currentIndex=0;

        }
      }

      reset();
      _isLoading = true;
      notifyListeners();
      await _playCurrentTrack();

  }

  Future<void> previousTrack() async {
    if(_isLoop==false)
      {
        print("left---");
        if (_currentIndex > 0)
        {
          if(isShuffled)
          {
            _currentIndex = findRandIndex();
          }
          if(!isShuffled)
          {
            _currentIndex--;
          }
          if(_currentIndex<0) _currentIndex=items.length;
        }
      }

    reset();
    _isLoading = true;
    notifyListeners();
    await _playCurrentTrack();

  }



  void toggleLoop() {
    _isLoop = !_isLoop;
    notifyListeners();
  }

  void setVolume(double value) {
    _volume = value;
    _audioPlayer.setVolume(_volume);
    notifyListeners();
  }

  void setSpeed(double value)
  {
    speed = value;
    _audioPlayer.setPlaybackRate(value);
  }


  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

class PlayListProvider extends ChangeNotifier
{
  Map<String, PlayListModel> playLists = {};
  String? currentName;

  bool isAlreadyExists({required String name})
  {
    return playLists.containsKey(name);
  }


  void createNewPlayList({required String name, required String imageUrl}) async
  {

    playLists[name] = PlayListModel(name: name, imageUrl: imageUrl);
    var fireStore = FirebaseFirestore.instance.collection('users').doc(userUid);
    notifyListeners();
  }

  void addTrackToPlayList({required BuildContext context, required String name, required TrackModel track})
  {
    if(playLists.containsKey(name))
    {
      playLists[name]!.tracks.add(track);
      showMessage(context: context, content: "Song added to playlist '$name'");
    }
    notifyListeners();
  }

  void setCurrentName(String name)
  {
    currentName = name;
    print("set $name");
    notifyListeners();
  }

  List<TrackModel> getTrackList({required String name})
  {
    return playLists[name]!.tracks;
  }

  List<String> getPlayListNames()
  {
    return playLists.keys.toList(growable: false);
  }

  void sortItems(String name, String sortBy)
  {
    var sortedList = playLists[name]!.tracks;
    sortTracks(sortedList, sortBy: sortBy);
    playLists[name]!.tracks= sortedList;
    notifyListeners();
  }

  bool checkInPlayList({required String name, required String trackId})
  {
    print("check $name");
    // if(playLists[name]!.tracks.contains(track)) return true;
    for(int i=0; i<playLists[name]!.tracks.length; i++)
      {
        if(playLists[name]!.tracks[i].id == trackId) return true;
      }
    return false;
  }

  void removeFromPlaylist({required BuildContext context, required String name, required String trackId})
  {
    for(int i=0; i<playLists[name]!.tracks.length; i++)
    {
      if(playLists[name]!.tracks[i].id == trackId)
        {
          playLists[name]!.tracks.removeAt(i);
          showMessage(context: context, content: "Song removed from '$name'");
        }
    }
    notifyListeners();
  }
}







//

//
// Future<Database> initDataBase() async {
//   final dbPath = path.join(await sql.getDatabasesPath(), 'favUser1.db');
//   final db = await sql.openDatabase(dbPath,
//       version: 1,
//       onCreate: (db, version) => db.execute(
//           'CREATE TABLE favouritesUser1 (id TEXT,name TEXT,artistId TEXT, artistName TEXT, albumId TEXT, albumName TEXT, imageUrl TEXT, userId TEXT)'));
//   print(dbPath);
//   return db;
// }
//
// void insertData(
//     {required String id,
//       required String name,
//       required String artistId,
//       required String artistName,
//       required String albumId,
//       required String albumName,
//       required String imageUrl}) async {
//   final db = await initDataBase();
//   // int numberOfInsertions = await db.rawInsert("INSERT INTO favourites(id, name, artistId, artistName, albumId, albumName, imageUrl) VALUES ('${id}', '${name}', '$artistId','$artistName', '$albumId', '$albumName', '$imageUrl')");
//   int numberOfInsertions = await db.insert('favouritesUser1', {
//     'id': id,
//     'name': name,
//     'artistId': artistId,
//     'artistName': artistName,
//     'albumId': albumId,
//     'albumName': albumName,
//     'imageUrl': imageUrl,
//     'userId': userUid
//   });
//   print(numberOfInsertions);
//   print(userUid);
// }
//
// void deleteData({required id}) async {
//   final db = await initDataBase();
//   int numberOfDeletions = await db.rawDelete(
//       'DELETE  FROM favouritesUser1 WHERE id=? AND userId=?', [id, userUid]);
//   print(numberOfDeletions);
// }
//
// dynamic getData() async {
//   final db = await initDataBase();
//   var res = await db
//       .rawQuery('SELECT * FROM favouritesUser1 WHERE userId= ? ', [userUid]);
//   print("from get data ${res[0]['userId']}");
//   return res;
// }
//
// Future<bool> checkData({required String id}) async {
//   final db = await initDataBase();
//   var res = await db.rawQuery(
//       'SELECT id FROM favouritesUser1 WHERE id = ? AND userId=?',
//       [id, userUid]);
//   return res.isNotEmpty;
// }


//
// class PlayListProvider extends ChangeNotifier {
//   Map<String, PlayListModel> privatePlayLists = {};
//   Map<String, PlayListModel> publicPlayLists = {};
//   String? currentName;
//
//   bool isAlreadyExists({required String name, required bool isPublic}) {
//     return isPublic ? publicPlayLists.containsKey(name) : privatePlayLists.containsKey(name);
//   }
//
//   Future<void> createNewPlayList({
//     required String name,
//     required String imageUrl,
//     required bool isPublic,
//   }) async {
//     PlayListModel newPlaylist = PlayListModel(name: name, imageUrl: imageUrl);
//
//     if (isPublic) {
//       publicPlayLists[name] = newPlaylist;
//     } else {
//       privatePlayLists[name] = newPlaylist;
//     }
//
//     var fireStore = FirebaseFirestore.instance.collection('users').doc(userUid);
//
//     // Store in Firestore
//     await fireStore.update({
//       isPublic ? 'publicPlayLists' : 'privatePlayLists': {
//         name: newPlaylist.toMap(),  // Convert playlist model to a map
//       }
//     });
//
//     notifyListeners();
//   }
//
//   void addTrackToPlayList({
//     required BuildContext context,
//     required String name,
//     required TrackModel track,
//     required bool isPublic,
//   }) async {
//     if (isPublic ? publicPlayLists.containsKey(name) : privatePlayLists.containsKey(name)) {
//       var playlist = isPublic ? publicPlayLists[name]! : privatePlayLists[name]!;
//       playlist.tracks.add(track);
//
//       var fireStore = FirebaseFirestore.instance.collection('users').doc(userUid);
//
//       // Update Firestore with the modified playlist
//       await fireStore.update({
//         isPublic ? 'publicPlayLists' : 'privatePlayLists': {
//           name: playlist.toMap(),  // Convert playlist model to a map
//         }
//       });
//
//       showMessage(context: context, content: "Song added to playlist '$name'");
//       notifyListeners();
//     }
//   }
//
//   List<TrackModel> getTrackList({required String name, required bool isPublic}) {
//     return isPublic ? publicPlayLists[name]!.tracks : privatePlayLists[name]!.tracks;
//   }
//
//   List<String> getPlayListNames(bool isPublic) {
//     return isPublic ? publicPlayLists.keys.toList(growable: false) : privatePlayLists.keys.toList(growable: false);
//   }
//
//   Future<void> removeFromPlaylist({
//     required BuildContext context,
//     required String name,
//     required String trackId,
//     required bool isPublic,
//   }) async {
//     var playlist = isPublic ? publicPlayLists[name]! : privatePlayLists[name]!;
//
//     for (int i = 0; i < playlist.tracks.length; i++) {
//       if (playlist.tracks[i].id == trackId) {
//         playlist.tracks.removeAt(i);
//
//         var fireStore = FirebaseFirestore.instance.collection('users').doc(userUid);
//
// 
//         await fireStore.update({
//           isPublic ? 'publicPlayLists' : 'privatePlayLists': {
//             name: playlist.toMap(),
//           }
//         });
//
//         showMessage(context: context, content: "Song removed from '$name'");
//         notifyListeners();
//         break;
//       }
//     }
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'imageUrl': imageUrl,
//       'tracks': tracks.map((track) => track.toMap()).toList(),
//     };
//   }
// }
