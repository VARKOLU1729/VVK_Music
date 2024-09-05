import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:runo_music/Data/top_tracks.dart';
import 'package:runo_music/Data/top_albums.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';
//Thins to include
// (Artist Details)
// Show the Artist Image, Bio.
/*
/v2.2/artists/Art.28463069/images
*/

// (Albums made by this Artist)
// Show the list of albums created by this artist (on click of it, open  Album View)

class ArtistView extends StatefulWidget {
  final String artistId;
  const ArtistView({super.key, required this.artistId});

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

  @override
  void initState() {
    super.initState();
    _artistTrackPagingController.addPageRequestListener((pageKey) {
      _loadTrackData(pageKey);
    });
    _artistAlbumPagingController.addPageRequestListener((pageKey) {
      _loadAlbumData(pageKey);
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
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "Top Tracks",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Container(
            height: 220,
            child: PagedListView<int, dynamic>(
                pagingController: _artistTrackPagingController,
                scrollDirection: Axis.horizontal,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                    itemBuilder: (context, item, index) {
                  return TrackAlbumWidget(
                    id: item[0],
                    name: item[1],
                    imageUrl: item[2],
                    artistId: item[3],
                    artistName: item[4],
                    type: Type.track,
                  );
                })),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "Top Albums",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Container(
            height: 220,
            child: PagedListView<int, dynamic>(
                pagingController: _artistAlbumPagingController,
                scrollDirection: Axis.horizontal,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                    itemBuilder: (context, item, index) {
                  return TrackAlbumWidget(
                    id: item[0],
                    name: item[1],
                    imageUrl: item[2],
                    artistId: item[3],
                    artistName: item[4],
                    type: Type.album,
                  );
                })),
          ),
        ],
      ),
    ));
  }
}
