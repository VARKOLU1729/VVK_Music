import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/audio_controllers/favourite_button.dart';
import 'package:vertical_slider/vertical_slider.dart';
import 'dart:math' as math;

import '../Helper/Responsive.dart';
import '../Helper/deviceParams.dart';

import '../audio_controllers/loop_button.dart';
import '../audio_controllers/next_button.dart';
import '../audio_controllers/previous_button.dart';
import '../audio_controllers/volume_button.dart';
import '../audio_controllers/play_pause_button.dart';

import '../Widgets/back_ground_blur.dart';
import '../Services/Providers/provider.dart';
import '../Widgets/pop_out.dart';
import '../Widgets/bottom_icon.dart';

import 'album_view.dart';
import 'artist_view.dart';





class MusicPlayerView extends StatefulWidget {
  
  const MusicPlayerView({super.key});
  
  @override
  State<MusicPlayerView> createState() => _MusicPlayerViewState();
}

class _MusicPlayerViewState extends State<MusicPlayerView> {

  bool _setVolume = false;

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
    duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

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

        final String trackId = track.id;
        final String trackName = track.name;
        final String trackImageUrl = track.imageUrl;
        final String artistId = track.artistId;
        final String artistName = track.artistName;
        final String albumId = track.albumId;
        final String albumName = track.albumName;

        bool addedToFav = favProvider.checkInFav(id: trackId);

        return Scaffold(
          body: Stack(
            children: [

              Image.network(
                trackImageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              const BackGroundBlur(),

              PopOut(
                onPress: () {
                    audioProvider.setMiniPlayer();
                    Navigator.pop(context);
                  },
                icon: Icons.keyboard_arrow_down,
              ),

              if (_setVolume)
                Positioned.directional(
                  textDirection: TextDirection.rtl,
                  end: getWidth(context) / 20,
                  top: getHeight(context) / 4,
                  bottom: getHeight(context) / 2,
                  child: VerticalSlider(
                    value: audioProvider.volume,
                    onChangeEnd: (val) {
                      setState(() {
                        _setVolume = false;
                      });
                    },
                    onChanged: (val) {
                      audioProvider.setVolume(val);
                    },
                  ),
                ),

              SizedBox(
                height: getHeight(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Spacer(),

                      if(getHeight(context)>500)
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child:  Image.network(
                                trackImageUrl,
                                height: Responsive.isSmallScreen(context) || Responsive.isMobile(context) ?  math.min(getHeight(context)*0.4, 200) : math.min(getHeight(context)*0.5, 300),
                                width: Responsive.isSmallScreen(context) || Responsive.isMobile(context)
                                    ? 200
                                    : (Responsive.isMediumScreen(context)
                                    ? math.max(300, getWidth(context) / 3.5)
                                    : math.min(getWidth(context) / 3.5, 400)),
                                fit: BoxFit.cover,
                              ),
                          ),
                      ),

                      const Spacer(),

                      SizedBox(
                        height: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Expanded(
                              flex:1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  //Track Name - on tap album View
                                  SizedBox(
                                    width: getWidth(context)/1.5,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AlbumView(
                                              albumId: albumId,
                                              albumName: albumName,
                                              albumImageUrl: trackImageUrl,
                                              artistId: artistId,
                                              artistName: artistName,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        trackName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: Responsive.isSmallScreen(context) || Responsive.isMobile(context)  ? 18 : 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                  //fav icon - on tap add/remove from fav
                                  favButton(
                                      onTap: () {
                                        favProvider.toggleFavourite(
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

                            //artist Name - on tap artist view
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ArtistView(
                                        artistId: artistId,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  artistName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize:  Responsive.isSmallScreen(context) || Responsive.isMobile(context) ? 14 : 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),


                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [

                                  Expanded(
                                    flex:1,
                                    child: SliderTheme(
                                      data: const SliderThemeData(
                                        trackHeight: 3,
                                        trackShape: RectangularSliderTrackShape(),
                                        overlayShape:
                                        RoundSliderOverlayShape(overlayRadius: 6),
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 5),
                                      ),
                                      child: Slider(
                                        allowedInteraction:
                                        SliderInteraction.tapAndSlide,
                                        thumbColor: Colors.white,
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.grey,
                                        value: audioProvider.duration.inMilliseconds > 0
                                            ? math.min(audioProvider.currentPosition.inMilliseconds /
                                            audioProvider.duration.inMilliseconds,1)
                                            : 0.0,
                                        min: 0.0,
                                        max: 1.0,
                                        onChanged: (value) {
                                          audioProvider.seekTo(value);
                                        },
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatDuration(audioProvider.currentPosition),
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          _formatDuration(audioProvider.duration),
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [

                                  if(!(Responsive.isSmallScreen(context) || Responsive.isMobile(context)))
                                  VolumeButton(
                                    audioProvider:audioProvider,
                                    onPress: () {
                                      setState(() {
                                        _setVolume = !_setVolume;
                                      });
                                    },
                                    iconSize: 20,
                                  ),

                                  PreviousButton(audioProvider: audioProvider, iconSize: 40),

                                  audioProvider.isLoading
                                      ? const CircularProgressIndicator(color: Colors.white,)
                                      : PlayPauseButton(iconSize: 40,isDecoration: true,),

                                  NextButton(audioProvider: audioProvider, iconSize: 40),

                                  if(!(Responsive.isSmallScreen(context) || Responsive.isMobile(context)))
                                  LoopButton(
                                      audioProvider: audioProvider,
                                      onPress: () {
                                        audioProvider.toggleLoop();
                                      },
                                      iconSize: 20),
                                ],
                              ),
                            ),

                            if(Responsive.isSmallScreen(context) || Responsive.isMobile(context))
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [

                                  bottomIcon(
                                    icon: VolumeButton(
                                      audioProvider:audioProvider,
                                      onPress: () {
                                        setState(() {
                                          _setVolume = !_setVolume;
                                        });
                                      },
                                      iconSize: 20,
                                    ),
                                  ),

                                  bottomIcon(
                                    icon: LoopButton(
                                      audioProvider: audioProvider,
                                          onPress: () {
                                            audioProvider.toggleLoop();
                                          },
                                        iconSize: 20),
                                  ),

                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
