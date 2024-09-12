import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:runo_music/Data/top_tracks.dart';
import 'package:runo_music/Data/top_albums.dart';
import 'package:runo_music/Helper/deviceParams.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';
import 'package:runo_music/Widgets/header.dart';
import 'package:runo_music/Widgets/pop_out.dart';
import 'package:runo_music/Widgets/display_with_pagination.dart';
import 'package:runo_music/Widgets/see_all.dart';

import '../Helper/Responsive.dart';
import '../Widgets/favourite_items_provider.dart';
import 'music_player_view.dart';



class ArtistView extends StatefulWidget {
  final String artistId;
  ArtistView({super.key, required this.artistId});

  @override
  State<ArtistView> createState() => _ArtistViewState();
}

class _ArtistViewState extends State<ArtistView> {
  String? artistImageUrl;
  String? artistName;
  String? artistBio;
  PagingController<int, dynamic> _artistTrackPagingController =
      PagingController(firstPageKey: 0);
  PagingController<int, dynamic> _artistAlbumPagingController =
      PagingController(firstPageKey: 0);

  void _loadTrackData(pageKey) async {
    List<List<dynamic>> trackData = await FetchTopTracks(
        path: 'artists/${widget.artistId}/tracks/top',
        controller: _artistTrackPagingController,
        pageKey: pageKey);
    _artistTrackPagingController.appendPage(trackData, pageKey + 1);
  }

  void _loadAlbumData(pageKey) async {
    List<List<dynamic>> albumData = await FetchTopAlbums(
        path: 'artists/${widget.artistId}/albums/top',
        controller: _artistAlbumPagingController,
        pageKey: pageKey);
    _artistAlbumPagingController.appendPage(albumData, pageKey + 1);
  }

  void _loadArtistData() async {
    var artistData = await fetchData(path: 'artists/${widget.artistId}');
    setState(() {
      artistBio = artistData['artists'][0]['bios'][0]['bio'];
      artistName = artistData['artists'][0]['name'];
      print(artistBio);
    });
  }

  void _loadImage() async {
    var imageUrl = await fetchData(path: '/artists/${widget.artistId}/images');
    setState(() {
      artistImageUrl = imageUrl['images'][1]['url'];
    });
  }

  @override
  void initState() {
    super.initState();
    _artistTrackPagingController.addPageRequestListener((pageKey) {
      _loadTrackData(pageKey);
    });
    _artistAlbumPagingController.addPageRequestListener((pageKey) {
      _loadAlbumData(pageKey);
    });
    _loadArtistData();
    _loadImage();
  }

  @override
  void dispose() {
    _artistTrackPagingController.dispose();
    _artistAlbumPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(200, 20, 23, 20),
        body: Column(
          children: [
            Stack(children: [
              Container(
                height: getHeight(context)/3.25,
                child: artistImageUrl == null
                    ? CircularProgressIndicator()
                    : Image.network(
                        artistImageUrl!,
                        width: getWidth(context),
                        height: getHeight(context),
                        fit: BoxFit.fitWidth,
                      ),
              ),
              Container(
                padding: EdgeInsets.only(top: 50),
                child: ListTile(
                  title: artistName == null
                      ? CircularProgressIndicator()
                      : Text(
                    artistName!,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  subtitle: Text("6L Monthly Listeners", style: TextStyle(color: Colors.white70),),
                  trailing: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.red.withOpacity(0.66),
                            Colors.red.withOpacity(0.99)
                          ]
                        )
                    ),
                    child: IconButton(onPressed: () async{
                      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
                      await audioProvider.loadAudio(trackList:  _artistTrackPagingController.itemList!,index:  0);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MusicPlayerView()),);


                    }, icon: Icon(Icons.play_arrow, size: 30,color: Colors.white,)),
                  ),
                ),
                margin: EdgeInsets.only(top: getHeight(context) / 4),
                height: getHeight(context) / 7,
                width: getWidth(context),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.black.withOpacity(0.05),
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.2)
                    ])),
              ),
              popOut(),
            ]),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Header(title: 'Top Tracks'),
                            InkWell(
                              onTap: () {

                                Widget widget = SeeAll(type:Type.track, pagingController: _artistTrackPagingController);
                                if(Responsive().isSmallScreen(context))
                                  showModalBottomSheet(
                                      constraints: BoxConstraints(minHeight:getHeight(context)),
                                      context: context,
                                      builder: (context) => widget);
                                else
                                {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>widget));
                                }

                              },
                              child: Container(
                                  width: 100,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                      child: Text("SEE MORE",
                                          style: TextStyle(color: Colors.white)))),
                            ),
                          ]
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DisplayWithPagination(
                        pagingController: _artistTrackPagingController,
                        type: Type.track),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Header(title: 'Top Albums'),
                            InkWell(
                              onTap: () {

                                Widget widget = SeeAll(type:Type.album, pagingController: _artistAlbumPagingController);
                                if(Responsive().isSmallScreen(context))
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) => widget);
                                else
                                {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>widget));
                                }


                              },
                              child: Container(
                                  width: 100,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                      child: Text("SEE MORE",
                                          style: TextStyle(color: Colors.white)))),
                            ),
                          ]
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DisplayWithPagination(
                        pagingController: _artistAlbumPagingController,
                        type: Type.album),
                    (artistName == null ||
                            artistBio == null ||
                            artistImageUrl == null)
                        ? CircularProgressIndicator()
                        : ListTile(
                            title: Text(artistName!,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  artistBio!,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              SingleChildScrollView(
                                                child:
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: [Colors.brown.withOpacity(0.88),Colors.black.withOpacity(0.88),Colors.black.withOpacity(0.88), Colors.black.withOpacity(0.55)])
                                                  ),
                                                  child:
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 100),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 40,),
                                                        Container(
                                                          height: 150,
                                                          width: 150,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(5),
                                                            child: Image.network(
                                                              artistImageUrl!,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 30,),
                                                        Text(
                                                          artistName!,
                                                          style: TextStyle(
                                                              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                                        ),
                                                        SizedBox(height: 30,),
                                                        Text(artistBio!, style: TextStyle(color: Colors.white),)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ));
                                    },
                                    child: Text("Read More",
                                        style: TextStyle(
                                            color: Colors.blueAccent)))
                              ],
                            ),
                            trailing: Container(
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  artistImageUrl!,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            )),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
