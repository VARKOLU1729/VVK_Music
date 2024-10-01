import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Services/Providers/provider.dart';

import '../Views/music_player_view.dart';


class Shuffle extends StatelessWidget {
  final void Function() onPressed;
  final AudioProvider audioProvider;
  const Shuffle({super.key, required this.onPressed, required this.audioProvider});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed,
        icon:  Icon(Icons.shuffle, color: audioProvider.isShuffled?Colors.blue:Colors.white,)
    );
  }
}
