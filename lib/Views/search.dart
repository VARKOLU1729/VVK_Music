import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Services/Data/fetch_data.dart';
import 'package:runo_music/Views/genre_view.dart';
import 'package:runo_music/main.dart';
import 'package:runo_music/tab_screen.dart';

import '../Helper/Responsive.dart';
import 'package:runo_music/Services/Data/searchResults.dart';
import '../Helper/loadingIndicator.dart';
import '../Widgets/list_all.dart';
import '../Widgets/mobile_app_bar2.dart';
import '../Widgets/search_bar.dart';

class Search extends StatefulWidget {
  final String? queryHomePage;
  final bool? backButton;
  const Search({super.key, this.queryHomePage, this.backButton});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final PagingController<int, dynamic> _searchPagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: 3);


  String _currentQuery = '';
  bool _isSearched = false;
  final _searchController = TextEditingController();
  bool _isLoading = true;

  List<dynamic> genreData = []; //list[[genre_id, genre_name, genre_description]]

  void fetchGenres() async
  {
    List<dynamic> tempData = [];
    try
    {
      var res = await fetchData(path: 'genres');
      for(var item in res['genres'])
      {
        tempData.add([item['id'], item['name'], item["description"]]);
      }
      setState(() {
        genreData = tempData;
        _isLoading = false;
      });
    }
    catch(error)
    {
      print(error);
    }
  }

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
    fetchGenres();
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
      final isLastPage = trackData.isEmpty || trackData.length<5;
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
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar:Responsive.isMobile() ? MobileAppBar2(context):null,
      backgroundColor: Colors.black,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(Responsive.isMobile())
          SizedBox(height: 100,),
          if(!Responsive.isMobile()) Responsive.isSmallScreen(context) ? SizedBox(height: 72,): SizedBox(height: 10,),
            Row(
              children: [
                Expanded(flex: 6,
                    child: searchBar(onSubmit: (val){search(val);},height: 45,isMarginReq: true,width: double.infinity,textController: _searchController)
                ),
                if(Responsive.isLargeScreen(context) ||  Responsive.isMediumScreen(context) || widget.backButton==true)
                Expanded(
                  flex: widget.backButton==true ? 2 :1,
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
                        firstPageProgressIndicatorBuilder: (context)=> loadingIndicator(),
                        newPageProgressIndicatorBuilder: (context)=> loadingIndicator(),
                        noMoreItemsIndicatorBuilder: (context)=>Center(child: Text("No More Items", style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 20),),),
                        noItemsFoundIndicatorBuilder: (context)=>Center(child: Text("No Items Found", style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 20),),),
                        itemBuilder: (context, item, index) {
                          return ListAllWidget(
                              items: _searchPagingController.itemList!,
                              index: index,
                            decorationReq: true,
                          );
                        })),
              ),
            ),

          if(!_isSearched)
          SizedBox(height: 40,),

          if(!_isSearched)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Text("Music By Genre", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20),)
                ],
              ),
            ),


          if(!_isSearched)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: GridView.builder(
                  padding: EdgeInsets.only(bottom: 120),
                  itemCount: genreData.length,
                    gridDelegate : SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 300, childAspectRatio: 2.5),
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.5),
                    itemBuilder: (context, index)
                    {
                      List<Color> gradientColors = [
                              Color.fromARGB(255, 220,40*index, 20*index),
                              Color.fromARGB(255, 2*index, 20*index, 191)
                            ];
                      return InkWell(
                        onTap:() {
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TabScreen(activePage: GenreView(genreData: genreData[index],gradientColors: gradientColors,),) ));
                          context.push('/genre-view',
                              extra: {
                              'genreData':genreData[index],
                                'gradientColors':gradientColors
                              }
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child:ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:Container(
                              alignment: Alignment.center,
                              width: 100,
                              height: 10,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: gradientColors
                                  )
                              ),
                              child: _isLoading ? CircularProgressIndicator() : Text('${genreData[index][1]}', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                            ),
                          )

                        ),
                      );
                    }
                ),
              ),
            ),

        ],
      ),
    );
  }
}
