import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../Helper/Responsive.dart';
import '../Data/searchResults.dart';
import '../Widgets/list_all.dart';
import '../Widgets/search_bar.dart';

class Search extends StatefulWidget {
  final String? queryHomePage;
  const Search({super.key, this.queryHomePage});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final PagingController<int, dynamic> _searchPagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: 3);

  String _currentQuery = '';
  bool _isSearched = false;
  final _searchController = TextEditingController();


  void noText()
  {
    if(_searchController.text=='') {
      setState(() {
        _isSearched = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.queryHomePage!=null) _searchController.text = widget.queryHomePage!;
    _searchController.addListener(noText);
    _searchPagingController.addPageRequestListener((pageKey) {
      _loadTrackData(pageKey, _currentQuery);
    });
    if(widget.queryHomePage!=null) search(widget.queryHomePage!);
  }

  void _loadTrackData(int pageKey, String query) async {
    try {
      List<dynamic> trackData = await FetchSearchTracks(
        path: 'search',
        Query: query,
        controller: _searchPagingController,
        pageKey: pageKey,
      );
      final isLastPage = trackData.isEmpty;
      if (isLastPage) {
        _searchPagingController.appendLastPage(trackData);
      } else {
        _searchPagingController.appendPage(trackData, pageKey + 1);
      }

    } catch (error) {
      _searchPagingController.error = error;
    }
  }

  void search(String query) {
    setState(() {
      _currentQuery = query;
      _isSearched = true;
    });
    _searchPagingController.refresh();
  }

  @override
  void dispose() {
    _searchPagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:Responsive.isMobile(context) ?AppBar(backgroundColor: Colors.black87,toolbarHeight: 5,):null,
      backgroundColor: Colors.black,
      body: Column(
        children: [
            Row(
              children: [
                Expanded(flex: 6,
                    // child:
                    // Container(
                    //   width: double.infinity,
                    //   margin:  EdgeInsets.only(left: 20, right: 20, top: 10),
                    //   height: 45,
                    //   child: TextField(
                    //     controller: _searchController,
                    //     style: TextStyle(color: Colors.black),
                    //     decoration: InputDecoration(
                    //         fillColor: Colors.white,
                    //         filled: true,
                    //         prefixIcon: Icon(Icons.search, color: Colors.grey,),
                    //         hintText: "Search music",
                    //         hintStyle: TextStyle(color: Colors.grey),
                    //         contentPadding: EdgeInsets.only(top: 10),
                    //         border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(50),
                    //             borderSide: BorderSide.none
                    //         )
                    //     ),
                    //     onSubmitted: (val){search(val);},
                    //
                    //   ),
                    // ),
                    child: searchBar(onSubmit: (val){search(val);},height: 45,isMarginReq: true,width: double.infinity,textController: _searchController)
          ),
                if(Responsive.isLargeScreen(context) ||  Responsive.isMediumScreen(context))
                Expanded(
                  flex: 1,
                    child: TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("CANCEL", style: TextStyle(color: Colors.white),)))
              ],
            ),

          if (_isSearched)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                child: PagedListView<int, dynamic>(
                    pagingController: _searchPagingController,
                    scrollDirection: Axis.vertical,
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
                        noItemsFoundIndicatorBuilder: (context)=>const Center(child: Text("No Items Found", style: TextStyle(color: Colors.red),),),
                        itemBuilder: (context, item, index) {
                          return ListAllWidget(
                              items: _searchPagingController.itemList!,
                              index: index);
                        })),
              ),
            ),
        ],
      ),
    );
  }
}
