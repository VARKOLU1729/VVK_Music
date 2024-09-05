import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/fetch_data.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';

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

  void _loadData(pageKey) async {
    // var newItems = List.generate(10, (index) => (pageKey * 10 + index), growable: false);
    var trackDetailsJson = await fetchData(
        path: 'tracks/top', limit: '5', offset: '${pageKey * 5}');
    var albumDetailsJson = await fetchData(
        path: 'albums/top', limit: '5', offset: '${pageKey * 5}');

    List<List<String>> trackData = [];
    List<List<String>> albumData = [];

    for (int i = 0; i < 5; i++) {
      var trackAlbumId = trackDetailsJson['tracks'][i]['albumId'];
      var trackId = trackDetailsJson['tracks'][i]['id'];
      var trackArtistId = trackDetailsJson['tracks'][i]['artistId'];
      var trackArtistName = trackDetailsJson['tracks'][i]['artistName'];
      var trackImageUrl = await fetchData(path: 'albums/$trackAlbumId/images');
      trackData.add([
        trackId,
        trackDetailsJson['tracks'][i]['name'],
        trackImageUrl['images'][3]['url'],
        trackArtistId,
        trackArtistName
      ]);
      var albumId = albumDetailsJson['albums'][i]['id'];
      var albumName = albumDetailsJson['albums'][i]["name"];
      var albumImageUrl = await fetchData(path: 'albums/$albumId/images');
      var albumArtistId =
      albumDetailsJson['albums'][i]['contributingArtists']['mainArtist'];
      var albumArtistName = albumDetailsJson['albums'][i]['artistName'];
      albumData.add([
        albumId,
        albumName,
        albumImageUrl['images'][3]['url'],
        albumArtistId,
        albumArtistName
      ]);
    }

    _trackPagingController.appendPage(trackData, pageKey + 1);
    _albumPagingController.appendPage(albumData, pageKey + 1);
  }

  @override
  void initState() {
    super.initState();
    _trackPagingController.addPageRequestListener((pageKey) {
      _loadData(pageKey);
    });
    _albumPagingController.addPageRequestListener((pageKey) {
      _loadData(pageKey);
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
