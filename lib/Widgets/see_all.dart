import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Widgets/list_all.dart';

class SeeAll extends StatefulWidget {
  void Function(List<dynamic> item) addToFavourite;
  final PagingController<int, dynamic> pagingController;

  SeeAll({required this.addToFavourite, required this.pagingController});
  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon:Icon(Icons.keyboard_arrow_left, color: Colors.white,size: 40,)
        ),
        backgroundColor: Colors.black.withOpacity(0.88),
        title: Text("Songs for You", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.abc_sharp))],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: PagedListView<int, dynamic>(
            pagingController: widget.pagingController,
            scrollDirection: Axis.vertical,
            builderDelegate: PagedChildBuilderDelegate<dynamic>(
                itemBuilder: (context, item, index) {
              return ListAllWidget(
                  pagingController : widget.pagingController,
                  index:index,
                  addToFavourite: widget.addToFavourite);
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
    );
  }
}
