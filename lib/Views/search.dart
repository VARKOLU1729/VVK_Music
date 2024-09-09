import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Widgets/see_all.dart';
import 'package:runo_music/Widgets/track_album_widget.dart';
import '../Data/searchResults.dart';
import '../Widgets/list_all.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final PagingController<int, dynamic> _searchPagingController =
      PagingController(firstPageKey: 0);

  String _currentQuery = '';
  bool _isSearched = false;

  @override
  void initState() {
    super.initState();
    // Add the page request listener here
    _searchPagingController.addPageRequestListener((pageKey) {
      print("initiated");
      _loadTrackData(pageKey, _currentQuery);
    });
  }

  void _loadTrackData(int pageKey, String query) async {
    print("searching");
    try {
      // Fetch your track data
      List<List<dynamic>> trackData = await FetchSearchTracks(
        path: 'search',
        Query: query,
        controller: _searchPagingController,
        pageKey: pageKey,
      );
      print(trackData);
      final isLastPage = trackData.isEmpty;
      if (isLastPage) {
        _searchPagingController.appendLastPage(trackData);
      } else {
        _searchPagingController.appendPage(trackData, pageKey + 1);
      }

      print('searched');
    } catch (error) {
      _searchPagingController.error = error;
    }
  }

  void search(String query) {
    print("into search");
    setState(() {
      _currentQuery = query;
      _isSearched = true; // Set this to true immediately
    });
    _searchPagingController.refresh(); // This will trigger the listener
  }

  @override
  void dispose() {
    _searchPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            height: 45,
            child: TextField(
              style: TextStyle(color: Colors.black),
             decoration: InputDecoration(
               fillColor: Colors.white,
               filled: true,
               prefixIcon: Icon(Icons.search, color: Colors.grey,),
               hintText: "Search music",
               hintStyle: TextStyle(color: Colors.grey),
               contentPadding: EdgeInsets.only(top: 10),
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(50),
                 borderSide: BorderSide.none
               )
             ),
              onSubmitted: (val) {
                print(val);
                search(val);
              },

            ),
          ),
          if (_isSearched)
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: PagedListView<int, dynamic>(
                    pagingController: _searchPagingController,
                    scrollDirection: Axis.vertical,
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
                        itemBuilder: (context, item, index) {
                      return ListAllWidget(
                          pagingController: _searchPagingController,
                          index: index);
                    })),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        end: Alignment.topCenter,
                        begin: Alignment.bottomCenter,
                        colors: [
                      Colors.black.withOpacity(0.99),
                      Colors.black.withOpacity(0.92),
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.88)
                    ])),
              ),
            ),
        ],
      ),
    );
  }
}
