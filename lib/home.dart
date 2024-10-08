import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Helper/loadingIndicator.dart';
import 'package:runo_music/Widgets/mobile_app_bar.dart';
import 'package:runo_music/Widgets/mobile_app_bar2.dart';
import 'package:runo_music/Widgets/play_round_button.dart';

import '../Helper/Responsive.dart';
import '../Helper/deviceParams.dart';

import '../Widgets/display_with_pagination.dart';
import '../Widgets/see_all.dart';
import '../Widgets/track_album_widget.dart';
import '../Widgets/header.dart';

import 'package:runo_music/Services/Data/top_tracks.dart';
import 'package:runo_music/Services/Data/top_albums.dart';
import 'package:runo_music/Services/Data/fetch_data.dart';
import 'package:runo_music/Services/Data/top_artists.dart';
import 'package:carousel_slider/carousel_controller.dart';

import 'models/track_model.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String stationId = "ps.10388500";
  String stationArtistName = "The Smiths, Elliott Smith, Aimee Mann";
  String stationImageUrl = "https://images.prod.napster.com/img/356x237/5/1/2/6/686215_356x237.jpg?width=356&height=237";
  List<dynamic> stationData = [];
  List<List<TrackModel>> stationTrackData = [];
  bool loadingData = true;
  final PagingController<int, dynamic> _trackPagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: 3);
  final PagingController<int, dynamic> _albumPagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: 3);
  final PagingController<int, dynamic> _artistPagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: 3);

  final ScrollController trackScrollController = ScrollController();
  final ScrollController albumScrollController = ScrollController();
  final ScrollController artistScrollController = ScrollController();


  
  void _loadTrackData(pageKey) async {
    List<dynamic> trackData = await FetchTopTracks(
        path: 'tracks/top',
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
        path: 'albums/top',
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
        path: 'artists/top',
        controller: _artistPagingController,
        pageKey: pageKey);
    if (artistData.isEmpty) {
      _artistPagingController.appendLastPage(artistData);
    } else {
      _artistPagingController.appendPage(artistData, pageKey + 1);
    }
  }

  void _loadStationData() async {
    try{
      var stationData = await fetchData(path: 'stations/$stationId');
      setState(() {
        stationArtistName = stationData['stations'][0]['artists'];
        stationImageUrl =
        stationData['stations'][0]['links']['largeImage']['href'];
      });
    }
    catch(error)
    {
      print("$error");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadStationData();
    _trackPagingController.addPageRequestListener((pageKey) {
      _loadTrackData(pageKey);
    });
    _albumPagingController.addPageRequestListener((pageKey) {
      _loadAlbumData(pageKey);
    });
    _artistPagingController.addPageRequestListener((pageKey) {
      _loadArtistData(pageKey);
    });
    fetchTopStations();
  }

  @override
  void dispose() {
    print("dispose called");
    // _trackPagingController.dispose();
    // _albumPagingController.dispose();
    // _artistPagingController.dispose();
    super.dispose();
  }


  Future<void> fetchTopStations() async {
    var data = await fetchData(path: 'stations/top', limit: '5', offset: '1');
    if (data != null) {
      List<dynamic> temp = [];
      for(int i=0; i<5; i++)
        {
          stationId = data['stations'][i]['id'];
          dynamic t = await fetchStationData(stationId);
          temp.add(t);
        }
      setState(() {
        stationData = temp;
      });
    }
    loadStationTrackData();
  }

  Future<List<dynamic>> fetchStationData(String stationId) async {
    var data = await fetchData(path: 'stations/$stationId');
    String stationName = data['stations'][0]['name'];
    String stationArtistsName = data['stations'][0]['artists'];
    String genreIds = data['stations'][0]['links']['genres']['ids'].join(',');
    String stationImageUrl = data['stations'][0]['links']['largeImage']['href'];
    return [stationName, stationArtistsName,stationImageUrl, genreIds];
  }

  int _currentStationIndex = 0;

  void loadStationTrackData() async
  {
    print("load");
    List<List<TrackModel>> tempStationTrackData = [];
    for(int i=0; i<5; i++)
    {
      List<TrackModel> tracks = [];
      print(stationData[i][3]);
      var trackDetailsJson = await fetchData(path: "genres/${stationData[i][3]}/tracks/top", limit: '2', offset: '0');
      for(int i=0; i <2; i++)
        {
          var track = await TrackModel.fromJson(trackDetailsJson['tracks'][i]) ;
          tracks.add(track);
        }
      tempStationTrackData.add(tracks);
    }
    setState(() {
      stationTrackData = tempStationTrackData;
    });
    loadingData = false;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar:Responsive.isMobile() ? MobileAppBar2(context, title: "Explore music"):null,
      backgroundColor: const Color.fromARGB(255, 18, 20, 25),
      body: Stack(children: [
        BackdropFilter(
          blendMode: BlendMode.srcOver,
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(
            color: Colors.black87.withOpacity(0.1),
          ),
        ),
        Padding(
          padding: Responsive.isMobile() ? MediaQuery.of(context).padding : EdgeInsets.zero,
          // padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50,),
                // first child
                if (Responsive.isMobile(context))
                  //   show the station image in the background and station details
                loadingData ? SizedBox(height: getHeight(context)/2.5 ,child: loadingIndicator()) : CarouselSlider.builder(
                  itemCount: stationData.length,
                  itemBuilder: (context, index, realIndex) {
                    final stationName = stationData[index][0];
                    final stationArtistName = stationData[index][1];
                    final stationImageUrl = stationData[index][2];
                    return StationCard(
                        stationName:stationName,
                        stationImageUrl: stationImageUrl,
                        stationArtistName: stationArtistName,
                      stationTracks: stationTrackData[index]
                    );
                  },
                  options: CarouselOptions(
                    pauseAutoPlayOnTouch: true,
                    height: getHeight(context) / 2.5,
                    viewportFraction: 1,
                    autoPlay: true,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentStationIndex = index;
                      });
                    },
                  ),
                ),

                // second child
                if (Responsive.isMobile(context))
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(stationData.length, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        '-',
                        style: TextStyle(
                          fontSize: 30,
                          color: _currentStationIndex == index ? Theme.of(context).colorScheme.tertiary : Colors.grey,
                        ),
                      ),
                    );
                  }),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //   second child
                    SizedBox(
                      height:Responsive.isMobile()?0: 90,
                    ),
                    // Third box
                    Header(

                      pagingController: _trackPagingController,
                        type: Type.track,
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
                      type: Type.album,
                        pagingController: _albumPagingController,
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
                      pagingController: _artistPagingController,
                        type: Type.artist,
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
                    ),

                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }


  Widget StationCard({required String stationName, required String stationImageUrl, required String stationArtistName, required List<TrackModel> stationTracks})
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: getHeight(context) / 2.5,
          width: getWidth(context),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(stationImageUrl, scale: 20),
                  fit: BoxFit.cover)),
          child: Stack(
              children:[
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.5)
                            ])),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "STATION",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                                title: Text(stationName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30)),
                                subtitle: Text("Based on $stationArtistName",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15)),
                                trailing: PlayRoundButton(items: stationTracks)
                            ),
                          ]),
                    ),
                  ),
                ),
              ]
          ),
        ),
        Container(
          color: Colors.black,
        )
      ],
    );
  }

}



