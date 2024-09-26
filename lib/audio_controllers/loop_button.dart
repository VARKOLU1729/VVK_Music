import 'package:flutter/material.dart';
import 'package:runo_music/Services/Providers/provider.dart';

class LoopButton extends StatelessWidget {
  final AudioProvider audioProvider;
  final double iconSize;
  final void Function() onPress;
  const LoopButton({super.key, required this.audioProvider,required this.onPress, required this.iconSize});

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
