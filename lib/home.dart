import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:runo_music/Helper/Responsive.dart';
import 'package:runo_music/Helper/deviceParams.dart';
import 'package:runo_music/Widgets/display_with_pagination.dart';
import 'package:runo_music/Widgets/see_all.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';
import 'package:runo_music/Widgets/header.dart';
import 'package:runo_music/Data/top_tracks.dart';
import 'package:runo_music/Data/top_albums.dart';

class Home extends StatefulWidget {

  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String stationId = "ps.10388500";
  String stationArtistName = "The Smiths, Elliott Smith, Aimee Mann";
  String stationImageUrl =
      "https://images.prod.napster.com/img/356x237/5/1/2/6/686215_356x237.jpg?width=356&height=237";

  PagingController<int, dynamic> _trackPagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 3);
  PagingController<int, dynamic> _albumPagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 3);

  void _loadTrackData(pageKey) async {
    List<List<dynamic>> trackData = await FetchTopTracks(
        path: 'tracks/top',
        controller: _trackPagingController,
        pageKey: pageKey);
    if(trackData.isEmpty) _trackPagingController.appendLastPage(trackData);
    else _trackPagingController.appendPage(trackData, pageKey + 1);
  }

  void _loadAlbumData(pageKey) async {
    List<List<String>> albumData = await FetchTopAlbums(
        path: 'albums/top',
        controller: _albumPagingController,
        pageKey: pageKey);
    if(albumData.isEmpty) _albumPagingController.appendLastPage(albumData);
    else _albumPagingController.appendPage(albumData, pageKey + 1);
  }

  void _loadStationData() async {
    var stationData = await fetchData(path: 'stations/$stationId');
    setState(() {
      stationArtistName = stationData['stations'][0]['artists'];
      stationImageUrl = stationData['stations'][0]['links']['largeImage']['href'];
    });

    print(stationArtistName);
    print(stationImageUrl);
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
  }

  @override
  void dispose() {
    _trackPagingController.dispose();
    _albumPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 20, 25),
      body: SingleChildScrollView(

        child:Stack(
          children: [
            // first child
            if(Responsive().isSmallScreen(context))
            //   show the station image in the backgorund
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: getHeight(context)/2.25,
                  child: Image.network(
                    stationImageUrl,
                    width: getWidth(context),
                    // height: getHeight(context)/2.25,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  color: Colors.black,
                )
              ],
            ),

            // second child

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              //   first child
                if(Responsive().isSmallScreen(context))
                //   show the station details on top of the image
                Container(
                  margin: EdgeInsets.only(top: getHeight(context) / 3.25),
                  height:getHeight(context) / 7.25,
                  // width: width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.5)
                          ])),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              "STATION",
                              style: TextStyle(color: Color.fromARGB(255, 12, 189, 189), fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ListTile(
                            title: Text("My Soundtrack",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30)),
                            subtitle: Text(
                                "Based on $stationArtistName",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15)
                            ),
                            trailing:
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Container(
                                color: Color.fromARGB(255, 12, 189, 189),
                                child: IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow, size: 30,)),
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),

                ),

               //   second child
                SizedBox(height: 60,),

                // Third box
                Header(
                    onTap: () {
                    Widget widget = SeeAll(type:Type.track, pagingController: _trackPagingController);
                    if(Responsive().isSmallScreen(context))
                    showBottomSheet(
                        context: context,
                        builder: (context) => widget);
                    else
                      {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>widget));
                      }
                  },
                    title: "Top Tracks"),
                
                SizedBox(
                  height: 10,
                ),
                DisplayWithPagination(
                    pagingController: _trackPagingController,
                    type: Type.track,
                ),

                Header(
                    onTap: () {
                    Widget widget = SeeAll(type:Type.album, pagingController: _albumPagingController);
                    if(Responsive().isSmallScreen(context))
                      showBottomSheet(
                          context: context,
                          builder: (context) => widget);
                    else
                    {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>widget));
                    }

                    },
                    title: "Top Tracks"),


                SizedBox(
                  height: 10,
                ),
                DisplayWithPagination(
                    pagingController: _albumPagingController,
                    type: Type.album
                )
              ],
            ),
            if(Responsive().isSmallScreen(context))
            Positioned(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child:
                  Text("Explore Music",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                  ),
                ),
                height: 40,
              ),
              //
            )
          ],
        ),

      ),
    );
  }
}
