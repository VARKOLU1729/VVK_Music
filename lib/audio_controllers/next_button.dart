import 'package:flutter/material.dart';
import 'package:runo_music/Widgets/favourite_items_provider.dart';

class NextButton extends StatelessWidget {
  AudioProvider audioProvider;
  double iconSize = 40;
  NextButton({super.key, required this.audioProvider, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: audioProvider.currentIndex <
          audioProvider.items.length - 1
          ? () {
        audioProvider.nextTrack();
      }
          : null,
      icon: Icon(
        Icons.skip_next,
        size: iconSize,
        color: audioProvider.currentIndex <
            audioProvider.items.length - 1
            ? Colors.white
            : Colors.grey,
      ),
    );
  }
}
