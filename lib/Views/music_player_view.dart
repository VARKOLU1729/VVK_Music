import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Views/artist_view.dart';
import 'package:runo_music/Views/album_view.dart';
import 'package:runo_music/Widgets/back_ground_blur.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:runo_music/Widgets/messenger.dart';
import 'package:runo_music/Widgets/pop_out.dart';
import 'package:vertical_slider/vertical_slider.dart';

import '../Widgets/favourite_items_provider.dart';

class MusicPlayerView extends StatefulWidget {
  List<dynamic>? items;
  int index;
  final PagingController<int, dynamic>? trackPagingController;

  MusicPlayerView(
      {super.key,
      this.items,
        this.trackPagingController,
        required this.index});


  @override
  State<MusicPlayerView> createState() => _MusicPlayerViewState();
}

class _MusicPlayerViewState extends State<MusicPlayerView> {
  AudioPlayer? _audioPlayer;
  double volume = 1;
  double height = 0;
  double width = 0;
  bool _isPlaying = false;
  bool _isLoading = true;
  Duration _duration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  String? _sourceUrl;
  bool addedToFav = false;
  bool _setvolume = false;
  bool _isLoop = false;
  String? trackId;
  String? trackName;
  String? trackImageUrl;
  String? artistId;
  String? artistName;
  String? albumId;
  String? albumName;
  bool isLastItem = false;
  bool isFirstItem = false;

  List<dynamic> items = [];
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;

  void initVariables()
  {
    _isPlaying = false;
    _isLoading = true;
    _duration = Duration.zero;
    _currentPosition = Duration.zero;
    _seekToPosition(0);
  }


  void loadTrackData(int index)
  {
    _audioPlayer = AudioPlayer();
    initVariables();
    if(index==0)
      {
        isFirstItem = true;
      }
    if(widget.items==null)
    {
      items = widget.trackPagingController!.itemList!;
    }
    else
    {
      if(index==items.length-1)
        {
          isLastItem = true;
        }
      items = widget.items!;
    }

    trackId = items[index][0];
    trackName = items[index][1];
    trackImageUrl = items[index][2];
    artistId = items[index][3];
    artistName = items[index][4];
    albumId = items[index][5];
    albumName = items[index][6];
    _initializeAudio();
    _initializeStreams();
  }

  @override
  void initState() {
    super.initState();
    loadTrackData(widget.index);
  }

  Future<void> _initializeAudio() async {
    try {
      final urlData = await fetchData(path: 'tracks/${trackId}');
      _sourceUrl = urlData['tracks'][0]['previewURL'];
      await _audioPlayer!.setSourceUrl(_sourceUrl!);
      await _audioPlayer!.resume();

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
    _positionSubscription = _audioPlayer!.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _durationSubscription = _audioPlayer!.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

  }

  Future<void> togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer!.pause();
    } else {
      await _audioPlayer!.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _seekToPosition(double value) async {
    final newPosition =
        Duration(seconds: (_duration.inSeconds * value).round());
    await _audioPlayer!.seek(newPosition);
    setState(() {
      _currentPosition = newPosition;
    });
  }

  @override
  void dispose() {
    _positionSubscription!.cancel();
    _durationSubscription!.cancel();
    _audioPlayer!.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double _calculateSliderValue() {
    if (_duration.inMilliseconds > 0 && _currentPosition<_duration-Duration(seconds: 1)) {
      return _currentPosition.inMilliseconds / _duration.inMilliseconds;
    }
    else if(_currentPosition>=_duration-Duration(seconds: 1))
      {

        _seekToPosition(0);
        if(_isLoop)
          {
            _audioPlayer!.resume();
            _isPlaying = true;
          }
        else
          {
            _audioPlayer!.pause();
            _isPlaying = false;
          }

      }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Consumer<favouriteItemsProvider>(builder: (context, value, child){
      if(value.favourite_items.containsKey(trackId)) addedToFav = true;
      return Scaffold(
        body: Stack(
          children: [
            Image.network(
              trackImageUrl!,
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
                      _audioPlayer!.setVolume(val);

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
                  SizedBox(height:80),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child:ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          scale: 0.6,
                          trackImageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
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
                                            albumId: albumId!,
                                            albumName: albumName!,
                                            albumImageUrl:
                                            trackImageUrl!,
                                            artistId: artistId!,
                                            artistName: artistName!,
                                          )));
                                },
                                child: Text(
                                  trackName!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    addedToFav = !addedToFav;
                                    if(addedToFav)
                                      {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration:Duration(milliseconds: 30) , content:addedSnackbarContent()));
                                        value.addToFavourite(id: trackId!, details: [trackId, trackName,trackImageUrl, artistId, artistName, albumId, albumName]);
                                      }
                                    else
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration:Duration(milliseconds: 30) , content:removedSnackbarContent()));
                                      value.removeFromFavourite(id: trackId!);
                                    }
                                  });
                                },
                                child: Icon(Icons.favorite,
                                    color: addedToFav ? Colors.red : Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ArtistView(
                                        artistId: artistId!,
                                      )));
                            },
                            child: Text(
                              artistName!,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: (){
                                    setState(() {
                                      if(widget.index>0)
                                      {
                                        _positionSubscription!.cancel();
                                        _durationSubscription!.cancel();
                                        _audioPlayer!.dispose();
                                        _isLoading = true;
                                        loadTrackData(widget.index--);
                                      }
                                      else
                                      {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("This is the first item")));
                                      }
                                    });
                                  },
                                  icon: (widget.index==0)? Icon(Icons.skip_previous,size: 40, color: Colors.grey,) :Icon(Icons.skip_previous,size: 40, color: Colors.white,)
                              ),
                              _isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : playPauseButton(
                                  isPlaying: _isPlaying,
                                  togglePlayback: togglePlayback
                              ),
                              IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _positionSubscription!.cancel();
                                      _durationSubscription!.cancel();
                                      _audioPlayer!.dispose();
                                      _isLoading = true;
                                      _duration = Duration();
                                      loadTrackData(widget.index++);
                                    });
                                  },
                                  icon: isLastItem ? Icon(Icons.skip_next,size: 40, color: Colors.grey,) : Icon(Icons.skip_next,size: 40, color: Colors.white,)
                              ),

                            ],
                          ),

                          SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              bottomIcon(icon:
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
                                      : Icon(Icons.volume_up, color: Colors.white, size: 20,)),),
                              bottomIcon(icon:
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoop = !_isLoop;
                                  });
                                },
                                icon:!_isLoop? Icon(Icons.loop, color: Colors.white,size: 20,):Icon(Icons.loop, color: Colors.blue,size: 20,),
                              ))

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
    );
  }
}

class bottomIcon extends StatelessWidget {
  final Widget icon;
  bottomIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: icon,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.grey.withOpacity(0.44),
                Colors.grey.withOpacity(0.22)
              ]),
          color: Colors.red,
          borderRadius: BorderRadius.circular(50)),
    );;
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
          iconSize: 40,
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
