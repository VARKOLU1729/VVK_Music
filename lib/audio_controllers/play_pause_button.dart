import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Services/Providers/provider.dart';

class PlayPauseButton extends StatelessWidget {
  final double iconSize;
  final bool isDecoration;
  const PlayPauseButton({super.key, required this.iconSize,required this.isDecoration});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    return Container(
      decoration: isDecoration ? BoxDecoration(
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
      ):null,
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
