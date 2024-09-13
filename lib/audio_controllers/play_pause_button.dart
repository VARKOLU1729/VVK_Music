import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Widgets/favourite_items_provider.dart';

class PlayPauseButton extends StatelessWidget {
  double iconSize = 10;
  PlayPauseButton({super.key, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.grey.withOpacity(0.44),
            Colors.grey.withOpacity(0.22),
          ],
        ),
        color: Colors.red,
        borderRadius: BorderRadius.circular(2*iconSize),
      ),
      child: IconButton(
        color: Colors.white,
        iconSize: iconSize,
        onPressed: () {
          audioProvider.togglePlayPause();
        },
        icon: audioProvider.isPlaying ? Icon(Icons.pause, size: iconSize,) : Icon(Icons.play_arrow, size: iconSize,),
      ),
    );
  }
}