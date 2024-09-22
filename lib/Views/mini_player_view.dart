import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Helper/deviceParams.dart';
import 'dart:math' as math;
import '../Helper/Responsive.dart';

import '../Widgets/provider.dart';

import '../audio_controllers/favourite_button.dart';
import '../audio_controllers/next_button.dart';
import '../audio_controllers/play_pause_button.dart';
import '../audio_controllers/loop_button.dart';
import '../audio_controllers/previous_button.dart';
import '../audio_controllers/volume_button.dart';


class MiniPlayerView extends StatefulWidget {

  const MiniPlayerView({super.key});

  @override
  State<MiniPlayerView> createState() => _MiniPlayerViewState();
}

class _MiniPlayerViewState extends State<MiniPlayerView> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AudioProvider, FavouriteItemsProvider>(
      builder: (context, audioProvider, favProvider, child) {
        final track = audioProvider.items.isNotEmpty
            ? audioProvider.items[audioProvider.currentIndex]
            : null;

        if (track == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'No track selected',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final String trackName = track.name;
        final String trackImageUrl = track.imageUrl;
        final String artistName = track.artistName;


        return Responsive.isSmallScreen(context) || Responsive.isMobile(context) ? ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    trackImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(trackName, style: const TextStyle(color: Colors.white),),
                subtitle: Text(artistName, style: const TextStyle(color: Colors.grey),),
                trailing:Row(mainAxisSize: MainAxisSize.min, children: [PlayPauseButton(iconSize: 25,isDecoration: false,), NextButton(audioProvider: audioProvider, iconSize: 25)],) ,
              ): MiniControls(audioProvider: audioProvider, favProvider: favProvider);
      },
    );
  }

}


class MiniControls extends StatefulWidget {

  final AudioProvider audioProvider;
  final FavouriteItemsProvider favProvider;
  const MiniControls({super.key,required this.audioProvider,required this.favProvider});

  @override
  State<MiniControls> createState() => _MiniControlsState();
}

class _MiniControlsState extends State<MiniControls> {

  bool setVolume = false;

  @override
  Widget build(BuildContext context) {

    final track = widget.audioProvider.items.isNotEmpty
        ? widget.audioProvider.items[widget.audioProvider.currentIndex]
        : null;

    final String trackId = track.id;
    final String trackName = track.name;
    final String trackImageUrl = track.imageUrl;
    final String artistName = track.artistName;

    bool addedToFav = widget.favProvider.checkInFav(id: trackId);

    return SizedBox(
      width: getWidth(context),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  trackImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(trackName, style: const  TextStyle(color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,),
              subtitle: Text(artistName, style: const TextStyle(color: Colors.grey),maxLines: 1,overflow: TextOverflow.ellipsis),
                      ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  if(Responsive.isLargeScreen(context))
                    LoopButton(audioProvider: widget.audioProvider, onPress: (){widget.audioProvider.toggleLoop();}, iconSize: 25),

                  PreviousButton(audioProvider: widget.audioProvider, iconSize: 30),

                  PlayPauseButton(iconSize: 30, isDecoration: true,),

                  NextButton(audioProvider: widget.audioProvider, iconSize: 30),

                  if(Responsive.isLargeScreen(context))
                    favButton(
                        onTap: () {
                          widget.favProvider.toggleFavourite(
                              id: trackId,
                              details: track,
                              context: context);
                          setState(() {
                            addedToFav = !addedToFav;
                          });
                        },
                        addedToFav: addedToFav)
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const Spacer(),
                if(setVolume)
                  SizedBox(
                    width: 150,
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
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: VolumeButton(audioProvider: widget.audioProvider, onPress: (){setState(() {
                    setVolume = !setVolume;
                  });}, iconSize: 25),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
