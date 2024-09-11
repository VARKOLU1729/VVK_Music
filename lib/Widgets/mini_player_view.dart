import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertical_slider/vertical_slider.dart';
import '../Widgets/back_ground_blur.dart';
import '../Widgets/favourite_items_provider.dart';
import '../Widgets/pop_out.dart';
import '../Views/album_view.dart';
import '../Views/artist_view.dart';
import '../Widgets/play_pause_button.dart';
import '../Widgets/bottom_icon.dart';
import 'dart:math' as math;


class MiniPlayerView extends StatefulWidget {
  @override
  State<MiniPlayerView> createState() => _MiniPlayerViewState();
}

class _MiniPlayerViewState extends State<MiniPlayerView> {
  bool _setVolume = false;
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
    duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
  @override
  Widget build(BuildContext context) {
    return Consumer2<AudioProvider, favouriteItemsProvider>(
      builder: (context, audioProvider, favProvider, child) {
        final track = audioProvider.items.isNotEmpty
            ? audioProvider.items[audioProvider.currentIndex]
            : null;

        if (track == null) {
          return Scaffold(
            body: Center(
              child: Text(
                'No track selected',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final String trackId = track[0];
        final String trackName = track[1];
        final String trackImageUrl = track[2];
        final String artistId = track[3];
        final String artistName = track[4];
        final String albumId = track[5];
        final String albumName = track[6];

        bool addedToFav = favProvider.checkInFav(id: trackId);

        return ListTile(
                title: Text(trackName, style: TextStyle(color: Colors.white),),
                subtitle: Text(artistName, style: TextStyle(color: Colors.grey),),
                trailing: PlayPauseButton(),
              );
      },
    );
  }

}