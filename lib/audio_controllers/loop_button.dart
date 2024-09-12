import 'package:flutter/material.dart';
import 'package:runo_music/Widgets/favourite_items_provider.dart';

class LoopButton extends StatelessWidget {
  AudioProvider audioProvider;
  double iconSize = 20;
  void Function() onPress;
  LoopButton({super.key, required this.audioProvider,required this.onPress, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPress,
      icon: Icon(
        Icons.loop,
        color: audioProvider.isLoop
            ? Colors.blue
            : Colors.white,
        size: iconSize,
      ),
    );
  }
}
