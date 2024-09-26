import 'package:flutter/material.dart';
import 'package:runo_music/Services/Providers/provider.dart';

class PreviousButton extends StatelessWidget {
  final AudioProvider audioProvider;
  final double iconSize;
  const PreviousButton({super.key, required this.audioProvider, required this.iconSize});

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
