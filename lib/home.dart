import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';
import 'package:runo_music/Data/top_tracks.dart';
import 'package:runo_music/Data/top_albums.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PagingController<int, dynamic> _trackPagingController =
  PagingController(firstPageKey: 0);
  PagingController<int, dynamic> _albumPagingController =
  PagingController(firstPageKey: 0);

  void _loadTrackData(pageKey) async
  {
    List<List<String>> trackData = await FetchTopTracks(path: 'tracks/top', controller: _trackPagingController, pageKey: pageKey);
    _trackPagingController.appendPage(trackData, pageKey+1);
  }

  void _loadAlbumData(pageKey) async
  {
    List<List<String>> albumData = await FetchTopAlbums(path:'albums/top', controller: _albumPagingController, pageKey: pageKey);
    _albumPagingController.appendPage(albumData, pageKey+1);
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

  }

  @override
  void dispose() {
    _trackPagingController.dispose();
    _albumPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                pagingController: _trackPagingController,
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
                pagingController: _albumPagingController,
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
    );
  }
}
