import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:runo_music/Data/top_tracks.dart';
import 'package:runo_music/Data/top_albums.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';
import 'package:runo_music/Widgets/header.dart';
import 'package:runo_music/Widgets/pop_out.dart';
import 'package:runo_music/Widgets/display_with_pagination.dart';
import 'package:runo_music/Widgets/see_all.dart';

//Thins to include
// (Artist Details)
// Show the Artist Image, Bio.
/*
/v2.2/artists/Art.28463069/images
*/

// (Albums made by this Artist)
// Show the list of albums created by this artist (on click of it, open  Album View)

class ArtistView extends StatefulWidget {
  final void Function(List<dynamic> item) addToFavourite;
  final String artistId;
  ArtistView({super.key, required this.artistId, required this.addToFavourite});

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
    var ctx = context;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color.fromARGB(200, 20, 23, 20),
        body: Column(
          children: [
            Stack(children: [
              Container(
                child: artistImageUrl == null
                    ? CircularProgressIndicator()
                    : Image.network(
                        artistImageUrl!,
                        width: width,
                        // height: height,
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: height / 12),
                  child: artistName == null
                      ? CircularProgressIndicator()
                      : Text(
                          artistName!,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 40),
                        ),
                ),
                margin: EdgeInsets.only(top: height / 6),
                height: height / 7,
                width: width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.black.withOpacity(0.05),
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7)
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
                                showModalBottomSheet(
                                  constraints: BoxConstraints(minHeight:height),
                                    context: context,
                                    builder: (context) => SeeAll(
                                        type:Type.track,
                                        addToFavourite: widget.addToFavourite,
                                        pagingController: _artistTrackPagingController));
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
                        type: Type.track,
                        addToFavourites: widget.addToFavourite!),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Header(title: 'Top Albums'),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => SeeAll(
                                        type:Type.album,
                                        addToFavourite: widget.addToFavourite,
                                        pagingController: _artistAlbumPagingController));
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
                        type: Type.album,
                        addToFavourites: widget.addToFavourite!),
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
                                                        colors: [Colors.black.withOpacity(0.88), Colors.black.withOpacity(0.55)])
                                                  ),
                                                  child:
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 40,
                                                        ),
                                                        Container(
                                                          height: 100,
                                                          width: 100,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child:
                                                                Image.network(
                                                              artistImageUrl!,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          artistName!,
                                                          style: TextStyle(
                                                              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                                        ),
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  artistImageUrl!,
                                  fit: BoxFit.cover,
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
