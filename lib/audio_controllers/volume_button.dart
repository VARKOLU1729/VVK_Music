import 'package:flutter/material.dart';
import 'package:runo_music/Widgets/favourite_items_provider.dart';

class VolumeButton extends StatelessWidget {
  AudioProvider audioProvider;
  double iconSize = 20;
  void Function() onPress;
  VolumeButton({super.key, required this.audioProvider,required this.onPress, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPress,
      icon: audioProvider.volume < 0.5
          ? (audioProvider.volume == 0
          ? Icon(Icons.volume_off,
          color: Colors.white)
          : Icon(Icons.volume_down,
          color: Colors.white))
          : Icon(Icons.volume_up,
          color: Colors.white, size: iconSize),
    );
  }
}
