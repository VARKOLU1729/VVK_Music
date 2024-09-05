import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:runo_music/fetch_data.dart';
class MusicPlayerView extends StatefulWidget {
  final String trackId;
  final String trackName;
  final String trackImageUrl;
  final String artistId;
  final String artistName;

  const MusicPlayerView({
    super.key,
    required this.trackId,
    required this.trackName,
    required this.trackImageUrl,
    required this.artistId,
    required this.artistName,
  });

  @override
  State<MusicPlayerView> createState() => _MusicPlayerViewState();
}

class _MusicPlayerViewState extends State<MusicPlayerView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  double height = 0;
  double width = 0;
  bool _isPlaying = false;
  bool _isLoading = true;
  Duration _duration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  String? _sourceUrl;
  bool _isOverLay = false;

  late final StreamSubscription<Duration> _positionSubscription;
  late final StreamSubscription<Duration> _durationSubscription;
  late final StreamSubscription<void> _onCompleteSubscription;

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

    _onCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _currentPosition = Duration.zero;
      });
    });
  }

  Future<void> togglePlayback() async {
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
    _onCompleteSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double _calculateSliderValue() {
    if (_duration.inMilliseconds > 0) {
      return _currentPosition.inMilliseconds / _duration.inMilliseconds;
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

          Positioned.fill(
            child: BackdropFilter(
              blendMode: BlendMode.darken,
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(
                color: Colors.black12.withOpacity(0.4),
              ),
            ),
          ),

          Positioned(
            child: Ink(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20)),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(color: Colors.white, Icons.keyboard_arrow_down)),
            ),
            left: 5,
            top: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Image.network(
                      widget.trackImageUrl,
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trackName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.artistName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
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
                            activeColor: Colors.red,
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
                      ],
                    )),
              ],
            ),
          ),
          // if(_isOverLay)
          // InkWell(
          //   onTa
          //   child: Positioned(
          //     bottom: 56,
          //     left: 0,
          //     child: Container(
          //       height: 40,
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     ),
          //     ),
          //   )
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
          onPressed: togglePlayback,
          icon: (!isPlaying) ? Icon(Icons.play_arrow) : Icon(Icons.pause)),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.red.withOpacity(0.99),
                Colors.red.withOpacity(0.66)
              ]),
          color: Colors.red,
          borderRadius: BorderRadius.circular(30)),
    );
  }
}
