import 'package:flutter/material.dart';
import 'package:runo_music/Widgets/favourite_items_provider.dart';

class PreviousButton extends StatelessWidget {
  AudioProvider audioProvider;
  double iconSize = 40;
  PreviousButton({super.key, required this.audioProvider, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: audioProvider.currentIndex > 0
          ? () {
        audioProvider.previousTrack();
      }
          : null,
      icon: Icon(
        Icons.skip_previous,
        size: iconSize,
        color: audioProvider.currentIndex > 0
            ? Colors.white
            : Colors.grey,
      ),
    );
  }
}
