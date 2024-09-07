import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:runo_music/Views/artist_view.dart';
import 'package:runo_music/Views/album_view.dart';
import 'package:runo_music/Widgets/back_ground_blur.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:runo_music/Widgets/pop_out.dart';
import 'package:vertical_slider/vertical_slider.dart';

class MusicPlayerView extends StatefulWidget {
  final String trackId;
  final String trackName;
  final String trackImageUrl;
  final String artistId;
  final String artistName;
  final String albumId;
  final String albumName;
  final void Function(List<String> item) addToFavourite;

  const MusicPlayerView(
      {super.key,
      required this.trackId,
      required this.trackName,
      required this.trackImageUrl,
      required this.artistId,
      required this.artistName,
      required this.albumId,
      required this.albumName,
      required this.addToFavourite});

  @override
  State<MusicPlayerView> createState() => _MusicPlayerViewState();
}

class _MusicPlayerViewState extends State<MusicPlayerView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  double volume = 1;
  double height = 0;
  double width = 0;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _isSongCompleted = false;
  Duration _duration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  String? _sourceUrl;
  bool addedToFav = false;
  bool _setvolume = false;
  bool _isLoop = false;

  late final StreamSubscription<Duration> _positionSubscription;
  late final StreamSubscription<Duration> _durationSubscription;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
    _initializeStreams();
  }

  Future<void> _initializeAudio() async {
    try {
      final urlData = await fetchData(path: 'tracks/${widget.trackId}');
      _sourceUrl = urlData['tracks'][0]['previewURL'];
      await _audioPlayer.setSourceUrl(_sourceUrl!);
      await _audioPlayer.resume();

      setState(() {
        _isPlaying = true;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading audio: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initializeStreams() {
    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

  }

  Future<void> togglePlayback() async {
    // if(_isSongCompleted)
    //   {
    //     _seekToPosition(0);
    //   }
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _seekToPosition(double value) async {
    final newPosition =
        Duration(seconds: (_duration.inSeconds * value).round());
    await _audioPlayer.seek(newPosition);
    setState(() {
      _currentPosition = newPosition;
    });
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double _calculateSliderValue() {
    if (_duration.inMilliseconds > 0 && _currentPosition<_duration) {
      return _currentPosition.inMilliseconds / _duration.inMilliseconds;
    }
    else if(_currentPosition>=_duration)
      {

        _seekToPosition(0);
        if(_isLoop)
          {
            _audioPlayer.resume();
            _isPlaying = true;
          }
        else
          {
            _audioPlayer.pause();
            _isPlaying = false;
          }

      }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black.withOpacity(0.99),
      // ),
      body: Stack(
        children: [
          Image.network(
            widget.trackImageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          BackGroundBlur(),
          popOut(),
          if(_setvolume) Positioned.directional(
              textDirection: TextDirection.rtl,
              end:width/20,
              top: height/4,
              bottom: height/2,
              child: VerticalSlider(
                value: volume,
                onChangeEnd: (val){
                  setState(() {
                    _setvolume = false;
                  });
                },
                onChanged: (val) {
                  setState(() {
                    volume = val;
                    _audioPlayer.setVolume(val);

                  },
                  );
                },
              )

          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:40),
                Expanded(
                  flex: 3,
                  child: Center(
                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        scale: 0.6,
                        widget.trackImageUrl,
                        fit: BoxFit.cover,
                      ),
                    ), 
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AlbumView(
                                              albumId: widget.albumId,
                                              albumName: widget.albumName,
                                              albumImageUrl:
                                                  widget.trackImageUrl,
                                              artistId: widget.artistId,
                                              artistName: widget.artistName,
                                              addToFavourite:
                                                  widget.addToFavourite,
                                            )));
                              },
                              child: Text(
                                widget.trackName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                widget.addToFavourite([
                                  widget.trackId,
                                  widget.trackName,
                                  widget.trackImageUrl,
                                  widget.artistId,
                                  widget.artistName,
                                  widget.albumId,
                                  widget.albumName
                                ]);
                                setState(() {
                                  addedToFav = !addedToFav;
                                  //add remove to fav here - if time is sufficient
                                });
                              },
                              child: Icon(Icons.favorite,
                                  color:
                                      addedToFav ? Colors.red : Colors.white),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ArtistView(
                                          artistId: widget.artistId,
                                          addToFavourite: widget.addToFavourite,
                                        )));
                          },
                          child: Text(
                            widget.artistName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SliderTheme(
                          data: SliderThemeData(
                              trackHeight: 3,
                              trackShape: RectangularSliderTrackShape(),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 6),
                              thumbShape:
                                  RoundSliderThumbShape(enabledThumbRadius: 5)),
                          child: Slider(
                            allowedInteraction: SliderInteraction.tapAndSlide,
                            thumbColor: Colors.white,
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                            value: _calculateSliderValue(),
                            min: 0.0,
                            max: 1.0,
                            onChanged: (value) {
                              _seekToPosition(value);
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_currentPosition),
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              _formatDuration(_duration),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : playPauseButton(
                                    isPlaying: _isPlaying,
                                    togglePlayback: togglePlayback)),
                        SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    _setvolume = !_setvolume;
                                  });
                                },
                                icon: volume < 0.5
                                    ? (volume == 0
                                    ? Icon(Icons.volume_off,
                                    color: Colors.white)
                                    : Icon(Icons.volume_down,
                                    color: Colors.white))
                                    : Icon(Icons.volume_up, color: Colors.white)),
                            SizedBox(height: 40,),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoop = !_isLoop;
                                  });
                                },
                                icon: Icon(Icons.loop, color: Colors.white,),
                            )

                          ],
                        )

                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class playPauseButton extends StatelessWidget {
  final bool isPlaying;
  final Function() togglePlayback;
  const playPauseButton(
      {super.key, required this.isPlaying, required this.togglePlayback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
          color: Colors.white,
          iconSize: 50,
          onPressed: togglePlayback,
          icon: (!isPlaying) ? Icon(Icons.play_arrow) : Icon(Icons.pause)),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.grey.withOpacity(0.44),
                Colors.grey.withOpacity(0.22)
              ]),
          color: Colors.red,
          borderRadius: BorderRadius.circular(40)),
    );
  }
}
