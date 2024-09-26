import 'package:flutter/material.dart';
import 'package:runo_music/Services/Providers/provider.dart';

class VolumeButton extends StatelessWidget {
  final AudioProvider audioProvider;
  final double iconSize;
  final void Function() onPress;
  const VolumeButton({super.key, required this.audioProvider,required this.onPress, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPress,
      icon: audioProvider.volume < 0.5
          ? (audioProvider.volume == 0
          ? const Icon(Icons.volume_off,
          color: Colors.white)
          : const Icon(Icons.volume_down,
          color: Colors.white))
          : Icon(Icons.volume_up,
          color: Colors.white, size: iconSize),
    );
  }
}
