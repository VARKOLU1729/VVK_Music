import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Widgets/see_all.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';
import '../Data/top_tracks.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  PagingController<int, dynamic> _searchPagingController =
  PagingController(firstPageKey: 0);

  void _loadTrackData(pageKey,String Query) async {
    List<List<dynamic>> trackData = await FetchTopTracks(
        path: 'search?query=${Query}',
        controller: _searchPagingController,
        pageKey: pageKey);
    _searchPagingController.appendPage(trackData, pageKey + 1);
  }


  void search(String Query)
  {
    _searchPagingController.addPageRequestListener((pageKey) {
      _loadTrackData(pageKey, Query);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            onSubmitted: (val){
              search(val);
            },
          ),
          Expanded(child: SeeAll(type: Type.track, pagingController: _searchPagingController))

        ],
      )
    );
  }
}
