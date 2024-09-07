import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Widgets/display_with_pagination.dart';
import 'package:runo_music/Widgets/see_all.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';
import 'package:runo_music/Widgets/header.dart';
import 'package:runo_music/Data/top_tracks.dart';
import 'package:runo_music/Data/top_albums.dart';

class Home extends StatefulWidget {
  void Function(List<String> item) addToFavourites;

  Home({super.key, required this.addToFavourites});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PagingController<int, dynamic> _trackPagingController =
      PagingController(firstPageKey: 0);
  PagingController<int, dynamic> _albumPagingController =
      PagingController(firstPageKey: 0);

  void _loadTrackData(pageKey) async {
    List<List<String>> trackData = await FetchTopTracks(
        path: 'tracks/top',
        controller: _trackPagingController,
        pageKey: pageKey);
    _trackPagingController.appendPage(trackData, pageKey + 1);
  }

  void _loadAlbumData(pageKey) async {
    List<List<String>> albumData = await FetchTopAlbums(
        path: 'albums/top',
        controller: _albumPagingController,
        pageKey: pageKey);
    _albumPagingController.appendPage(albumData, pageKey + 1);
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
          Container(
            height: 300,
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.orange, Colors.green])),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Header(title: 'Top Tracks'),
            TextButton(
              onPressed: () {
                showBottomSheet(
                    context: context,
                    builder: (context) => SeeAll(
                        addToFavourite: widget.addToFavourites,
                        pagingController: _trackPagingController)
                );
              },
              child: Text("See All", style: TextStyle(color: Colors.white)),
            )
          ]),
          SizedBox(
            height: 10,
          ),
          DisplayWithPagination(
              pagingController: _trackPagingController,
              type: Type.track,
              addToFavourites: widget.addToFavourites),
          Header(title: 'Top Albums'),
          SizedBox(
            height: 10,
          ),
          DisplayWithPagination(
              pagingController: _albumPagingController,
              type: Type.album,
              addToFavourites: widget.addToFavourites)
        ],
      ),
    );
  }
}
