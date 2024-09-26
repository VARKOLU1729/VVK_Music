import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart';

import '../../Helper/Responsive.dart';
import '../../Helper/messenger.dart';
import '../Data/fetch_data.dart';
import '../../models/track_model.dart';

import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

final userUid = FirebaseAuth.instance.currentUser!.uid;

Future<Database> initDataBase() async
{
  final dbPath = path.join(await sql.getDatabasesPath(), 'favUser1.db');
  final db = await sql.openDatabase(dbPath, version: 1, onCreate: (db, version)=>db.execute('CREATE TABLE favouritesUser1 (id TEXT,name TEXT,artistId TEXT, artistName TEXT, albumId TEXT, albumName TEXT, imageUrl TEXT, userId TEXT)'));
  return db;
}

void insertData(Database db, {required String id,required String name,required  String artistId,required  String artistName,required  String albumId,required  String albumName,required  String imageUrl}) async
{
  // int numberOfInsertions = await db.rawInsert("INSERT INTO favourites(id, name, artistId, artistName, albumId, albumName, imageUrl) VALUES ('${id}', '${name}', '$artistId','$artistName', '$albumId', '$albumName', '$imageUrl')");
  int numberOfInsertions = await db.insert(
    'favouritesUser1',
    {
      'id':id,
      'name':name,
      'artistId':artistId,
      'artistName':artistName,
      'albumId':albumId,
      'albumName':albumName,
      'imageUrl':imageUrl,
      'userId' : userUid
    }
  );
  print(numberOfInsertions);
}

void deleteData(Database db, {required id}) async
{
  int numberOfDeletions = await db.rawDelete("DELETE  FROM favouritesUser1 WHERE id='$id' AND userId='$userUid'");
  print(numberOfDeletions);
}

dynamic getData(Database db) async
{
  var res = await db.rawQuery("SELECT * FROM favouritesUser1 WHERE userId='$userUid' ");
  return res;
}

Future<bool> checkData(Database db, {required String id}) async
{
  var res = await db.rawQuery("SELECT id FROM favouritesUser1 WHERE id = '$id' AND userId='$userUid'");
  return res.isNotEmpty;
}

class FavouriteItemsProvider extends ChangeNotifier {
  Map<String, TrackModel> favouriteItems = {};
  Database? db;

  FavouriteItemsProvider() {
    if(Responsive.isMobile())
      {
        _loadDataBase();
        _loadFavouriteItems();
      }
  }

  Future<void> _loadDataBase() async
  {
    db = await initDataBase();
  }

  void _loadFavouriteItems() async {

    final data = await getData(db!);

    for (var item in data) {
      final track = TrackModel(
        id: item['id']!.toString(),
        name: item['name']!.toString(),
        artistId: item['artistId']!.toString(),
        artistName: item['artistName']!.toString(),
        albumId: item['albumId']!.toString(),
        albumName: item['albumName']!.toString(),
        imageUrl: item['imageUrl']!.toString(),
      );
      favouriteItems[item['id']!.toString()] = track;
    }

    notifyListeners();
  }

  void addToFavourite({required String id, required TrackModel details}) {
    favouriteItems[id] = details;
    if(Responsive.isMobile())
    insertData(db!, id: details.id,name: details.name, artistId: details.artistId, artistName: details.artistName, albumId: details.albumId, albumName: details.albumName, imageUrl: details.imageUrl);
    notifyListeners();
  }

  void removeFromFavourite({required String id}) {
    favouriteItems.remove(id);
    if(Responsive.isMobile())
    deleteData(db!, id: id);
    notifyListeners();
  }

  bool checkInFav({required String id}) {
    if (favouriteItems.containsKey(id)) return true;
    return false;
  }

  void toggleFavourite({ required String id, required TrackModel details, required BuildContext context}) {
    if (checkInFav(id: id)) {
      removeFromFavourite(id: id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: const Duration(milliseconds: 30),content: removedSnackbarContent()),
      );
    } else {
      addToFavourite(id: id, details: details);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: const Duration(milliseconds: 30),content: addedSnackbarContent()),
      );
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
  double _volume = 1.0;
  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;
  bool openMiniPlayer = false;

  void setMiniPlayer()
  {
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
  String? get trackName => _items.isNotEmpty ? _items[_currentIndex].name : null;
  String? get trackImageUrl => _items.isNotEmpty ? _items[_currentIndex].imageUrl : null;
  String? get artistId => _items.isNotEmpty ? _items[_currentIndex].artistId : null;
  String? get artistName => _items.isNotEmpty ? _items[_currentIndex].artistName : null;
  String? get albumId => _items.isNotEmpty ? _items[_currentIndex].albumId : null;
  String? get albumName => _items.isNotEmpty ? _items[_currentIndex].albumName : null;

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

    _audioPlayer.onPlayerComplete.listen((event) {
      if (_isLoop) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.resume();
      } else {
        nextTrack();
      }
    });
  }

  Future<void> loadAudio({required List<dynamic> trackList,required int index}) async {
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

  void togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void seekTo(double value) {
    final newPosition = Duration(
        milliseconds: (_duration.inMilliseconds * value).round());
    _audioPlayer.seek(newPosition);
  }

  Future<void> nextTrack() async {
    if (_currentIndex < _items.length - 1) {
      _currentIndex++;
      _isLoading = true;
      notifyListeners();
      await _playCurrentTrack();
    }
  }

  Future<void> previousTrack() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      _isLoading = true;
      notifyListeners();
      await _playCurrentTrack();
    }
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


  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
