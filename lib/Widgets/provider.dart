import "package:flutter/material.dart";
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart';

import '../Helper/messenger.dart';
import '../Data/fetch_data.dart';
import '../models/track_model.dart';

import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

Future<Database> initDataBase() async
{
  final dbPath = path.join(await sql.getDatabasesPath(), 'fav.db');
  final db = await sql.openDatabase(dbPath, version: 1, onCreate: (db, version)=>db.execute('CREATE TABLE favourites (id TEXT PRIMARY KEY, name TEXT,artistId TEXT, artistName TEXT, albumId TEXT, albumName TEXT, imageUrl TEXT )'));
  return db;
}

void insertData({required String id,required String name,required  String artistId,required  String artistName,required  String albumId,required  String albumName,required  String imageUrl}) async
{
  final db = await initDataBase();
  int numberOfInsertions = await db.rawInsert("INSERT INTO favourites(id, name, artistId, artistName, albumId, albumName, imageUrl) VALUES ('$id', '${name}', '$artistId','$artistName', '$albumId', '$albumName', '$imageUrl')");
  print(numberOfInsertions);
}

void deleteData({required id}) async
{
  final db = await initDataBase();
  int numberOfDeletions = await db.rawDelete("DELETE FROM favourites WHERE id='$id'");
  print(numberOfDeletions);
}

dynamic getData() async
{
  final db = await initDataBase();
  var res = await db.rawQuery("SELECT * FROM favourites");
  return res;
}

class FavouriteItemsProvider extends ChangeNotifier {
  Map<String, TrackModel> favouriteItems = {};

  void addToFavourite({required String id, required TrackModel details}) {
    favouriteItems[id] = details;
    insertData(id: details.id,name: details.name, artistId: details.artistId, artistName: details.artistName, albumId: details.albumId, albumName: details.albumName, imageUrl: details.imageUrl);
    notifyListeners();
  }

  void removeFromFavourite({required String id}) {
    favouriteItems.remove(id);
    deleteData(id: id);
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
