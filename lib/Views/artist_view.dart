import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:runo_music/Data/top_tracks.dart';
import 'package:runo_music/Data/top_albums.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';
import 'package:runo_music/Widgets/header.dart';
import 'package:runo_music/Widgets/pop_out.dart';
import 'package:runo_music/Widgets/display_with_pagination.dart';
//Thins to include
// (Artist Details)
// Show the Artist Image, Bio.
/*
/v2.2/artists/Art.28463069/images
*/

// (Albums made by this Artist)
// Show the list of albums created by this artist (on click of it, open  Album View)

class ArtistView extends StatefulWidget {
  final void Function(List<String> item) addToFavourite;
  final String artistId;
  ArtistView({super.key, required this.artistId,required this.addToFavourite});

  @override
  State<ArtistView> createState() => _ArtistViewState();
}

class _ArtistViewState extends State<ArtistView> {
  String? artistImageUrl;
  PagingController<int, dynamic> _artistTrackPagingController =
      PagingController(firstPageKey: 0);
  PagingController<int, dynamic> _artistAlbumPagingController =
      PagingController(firstPageKey: 0);

  void _loadTrackData(pageKey) async {
    List<List<String>> trackData = await FetchTopTracks(
        path: 'tracks/top',
        controller: _artistTrackPagingController,
        pageKey: pageKey);
    _artistTrackPagingController.appendPage(trackData, pageKey + 1);
  }

  void _loadAlbumData(pageKey) async {
    List<List<String>> albumData = await FetchTopAlbums(
        path: 'albums/top',
        controller: _artistAlbumPagingController,
        pageKey: pageKey);
    _artistAlbumPagingController.appendPage(albumData, pageKey + 1);
  }

  void _loadImage() async
  {
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
      _loadImage();
    });
  }

  @override
  void dispose() {
    _artistTrackPagingController.dispose();
    _artistAlbumPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(200, 20, 23, 20),
        body:Column(
          children: [
            Stack(
              children: [
                Container(
                  child: artistImageUrl==null?CircularProgressIndicator() : Image.network(
                      artistImageUrl!,
                    width: width,
                    // height: height,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  child:
                  Padding(
                    padding: EdgeInsets.only(top : height/12),
                    child: Text(
                        "Shaboozey",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40
                      ),
                    ),
                  ),
                  margin: EdgeInsets.only(top: height/6),
                  height: height/7,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black.withOpacity(0.05),Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.7)]
                      )
                    ),
                  ),
                popOut(),
            ]
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Header(title: 'Top Tracks'),
                    SizedBox(height: 10,),
                    DisplayWithPagination(pagingController: _artistTrackPagingController,type: Type.track, addToFavourites:widget.addToFavourite!),
                    Header(title: 'Top Albums'),
                    SizedBox(height: 10,),
                    DisplayWithPagination(pagingController: _artistAlbumPagingController, type: Type.album, addToFavourites:widget.addToFavourite!)
                  ],
                ),
              ),
            )
          ],
        ) 
        
        );
  }
}
