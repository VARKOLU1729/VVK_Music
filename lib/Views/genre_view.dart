import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Widgets/play_text_button.dart';

import '../Helper/Responsive.dart';
import '../Helper/deviceParams.dart';

import '../Widgets/display_with_pagination.dart';
import '../Widgets/provider.dart';
import '../Widgets/see_all.dart';
import '../Widgets/track_album_widget.dart';
import '../Widgets/header.dart';

import '../Data/top_tracks.dart';
import '../Data/top_albums.dart';
import '../Data/fetch_data.dart';
import '../Data/top_artists.dart';
import 'music_player_view.dart';


class GenreView extends StatefulWidget {
  final List<dynamic> genreData;
  final List<Color> gradientColors;
  const GenreView({super.key, required this.genreData, required this.gradientColors});

  @override
  State<GenreView> createState() => _GenreViewState();
}

class _GenreViewState extends State<GenreView> {

  final PagingController<int, dynamic> _trackPagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: 3);
  final PagingController<int, dynamic> _albumPagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: 3);
  final PagingController<int, dynamic> _artistPagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: 3);

  final ScrollController trackScrollController = ScrollController();
  final ScrollController albumScrollController = ScrollController();
  final ScrollController artistScrollController = ScrollController();


  void _loadTrackData(pageKey) async {
    List<dynamic> trackData = await FetchTopTracks(
        path: 'genres/${widget.genreData[0]}/tracks/top',
        controller: _trackPagingController,
        pageKey: pageKey);
    if (trackData.isEmpty)
    {
      _trackPagingController.appendLastPage(trackData);
    }
    else
    {
      _trackPagingController.appendPage(trackData, pageKey + 1);
    }
  }

  void _loadAlbumData(pageKey) async {
    List<dynamic> albumData = await FetchTopAlbums(
        path: 'genres/${widget.genreData[0]}/albums/top',
        controller: _albumPagingController,
        pageKey: pageKey);
    if (albumData.isEmpty) {
      _albumPagingController.appendLastPage(albumData);
    } else {
      _albumPagingController.appendPage(albumData, pageKey + 1);
    }
  }

  void _loadArtistData(pageKey) async {
    List<dynamic> artistData = await FetchTopArtists(
        path: 'genres/${widget.genreData[0]}/artists/top',
        controller: _artistPagingController,
        pageKey: pageKey);
    if (artistData.isEmpty) {
      _artistPagingController.appendLastPage(artistData);
    } else {
      _artistPagingController.appendPage(artistData, pageKey + 1);
    }
  }


  @override
  void initState() {
    super.initState();
    _trackPagingController.addPageRequestListener((pageKey) {
      _loadTrackData(pageKey);
    });
    _albumPagingController.addPageRequestListener((pageKey) {
      _loadAlbumData(pageKey);
    });
    _artistPagingController.addPageRequestListener((pageKey) {
      _loadArtistData(pageKey);
    });
  }

  @override
  void dispose() {
    _trackPagingController.dispose();
    _albumPagingController.dispose();
    _artistPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var audioProvider = Provider.of<AudioProvider>(context, listen: false);
    return Scaffold(
      // appBar:AppBar(backgroundColor: Colors.white.withOpacity(0.001),toolbarHeight: 60,leading: IconButton(onPressed: (){Navigator.pop(context);}, icon:Icon(Icons.keyboard_arrow_left, size: 40, color: Colors.white),) ),
      // backgroundColor: const Color.fromARGB(255, 18, 20, 25),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: widget.gradientColors)
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: 60,),

              Text('${widget.genreData[1]}', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 60, color: Colors.white),),

              const SizedBox(height: 20,),

              if(_trackPagingController.itemList!=null)
              PlayTextButton(trackList: _trackPagingController.itemList!),

              Container(
                width: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromARGB(255, 11, 228, 228)
                ),
                child: TextButton(onPressed: () async{
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MusicPlayerView()),);
                  await audioProvider.loadAudio(trackList:_trackPagingController.itemList!,index:0);

                }, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [Icon(Icons.play_arrow, color: Colors.black87,), Text('Play', style: TextStyle(color: Colors.black87),)],)),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //   second child
                  const SizedBox(
                    height: 20,
                  ),
                  // Third box
                  Header(
                      onTap: () {
                        Widget widget = SeeAll(
                            type: Type.track,
                            pagingController: _trackPagingController);
                        if (Responsive.isMobile(context)) {
                          showBottomSheet( context: context, builder: (context) => widget);
                        } else {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => widget));
                        }
                      },
                      scrollController: trackScrollController,
                      title: "Top Tracks"),

                  const SizedBox(
                    height: 10,
                  ),
                  DisplayWithPagination(
                      pagingController: _trackPagingController,
                      type: Type.track,
                      scrollController : trackScrollController
                  ),

                  Header(
                      onTap: () {
                        Widget widget = SeeAll(
                            type: Type.album,
                            pagingController: _albumPagingController);
                        if (Responsive.isMobile(context)) {
                          showBottomSheet( context: context, builder: (context) => widget);
                        } else {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => widget));
                        }
                      },
                      title: "Top Albums",
                      scrollController: albumScrollController
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  DisplayWithPagination(
                      pagingController: _albumPagingController,
                      type: Type.album,
                      scrollController : albumScrollController
                  ),

                  Header(
                      onTap: () {
                        Widget widget = SeeAll(
                            type: Type.artist,
                            pagingController: _artistPagingController);
                        if (Responsive.isMobile(context)) {
                          showBottomSheet( context: context, builder: (context) => widget);
                        } else {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => widget));
                        }
                      },
                      title: "Top Artists",
                      scrollController: artistScrollController
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  DisplayWithPagination(
                      pagingController: _artistPagingController,
                      type: Type.artist,
                      scrollController : artistScrollController
                  )
                ],
              ),
            ],
          ),
        ),
        Positioned(
          child: Container(
            height: 60,
            color: Colors.black.withOpacity(0.01),
            child: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,))
          ),
          //
        ),
      ]),
    );
  }
}
