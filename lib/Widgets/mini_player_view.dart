import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Helper/Responsive.dart';
import 'package:runo_music/Helper/deviceParams.dart';
import 'package:runo_music/audio_controllers/loop_button.dart';
import 'package:runo_music/audio_controllers/previous_button.dart';
import 'package:runo_music/audio_controllers/volume_button.dart';
import 'package:vertical_slider/vertical_slider.dart';
import '../Widgets/back_ground_blur.dart';
import '../Widgets/favourite_items_provider.dart';
import '../Widgets/pop_out.dart';
import '../Views/album_view.dart';
import '../Views/artist_view.dart';
import '../audio_controllers/next_button.dart';
import '../audio_controllers/play_pause_button.dart';
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


        return Responsive().isSmallScreen(context) ? ListTile(
                leading: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      trackImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(trackName, style: TextStyle(color: Colors.white),),
                subtitle: Text(artistName, style: TextStyle(color: Colors.grey),),
                trailing: PlayPauseButton(iconSize: 25,),
              ): miniControls(audioProvider: audioProvider, favProvider: favProvider);
      },
    );
  }

}


class miniControls extends StatefulWidget {
  AudioProvider audioProvider;
  favouriteItemsProvider favProvider;
  miniControls({super.key,required this.audioProvider,required this.favProvider});

  @override
  State<miniControls> createState() => _miniControlsState();
}

class _miniControlsState extends State<miniControls> {
  bool setVolume = false;
  @override
  Widget build(BuildContext context) {
    final track = widget.audioProvider.items.isNotEmpty
        ? widget.audioProvider.items[widget.audioProvider.currentIndex]
        : null;
    final String trackId = track[0];
    final String trackName = track[1];
    final String trackImageUrl = track[2];
    final String artistId = track[3];
    final String artistName = track[4];
    final String albumId = track[5];
    final String albumName = track[6];
    bool addedToFav = widget.favProvider.checkInFav(id: trackId);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListTile(
            leading: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  trackImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(trackName, style: TextStyle(color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,),
            subtitle: Text(artistName, style: TextStyle(color: Colors.grey),maxLines: 1,overflow: TextOverflow.ellipsis),
                    ),
          ),
        ),

        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                if(Responsive().isLargeScreen(context)) LoopButton(audioProvider: widget.audioProvider, onPress: (){widget.audioProvider.toggleLoop();}, iconSize: 25),
                PreviousButton(audioProvider: widget.audioProvider, iconSize: 30),
                PlayPauseButton(iconSize: 30),
                NextButton(audioProvider: widget.audioProvider, iconSize: 30),
                if(Responsive().isLargeScreen(context))
                InkWell(
                  onTap: () {
                    widget.favProvider.toggleFavourite(
                        id: track[0],
                        details: track,
                        context: context);
                  },
                  child: Icon(
                    Icons.favorite,
                    color: addedToFav ? Colors.red : Colors.white,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VolumeButton(audioProvider: widget.audioProvider, onPress: (){setState(() {
                  setVolume = !setVolume;
                });}, iconSize: 25),
                if(setVolume)
                  Expanded(
                    child: Slider(
                      value: widget.audioProvider.volume,
                      onChangeEnd: (val) {
                        setState(() {
                          setVolume = false;
                        });
                      },
                      onChanged: (val) {
                        widget.audioProvider.setVolume(val);
                      },
                    ),
                  ),
              ],
            ),
        )
      ],
    );
  }
}