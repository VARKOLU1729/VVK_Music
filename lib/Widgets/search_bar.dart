import 'package:flutter/material.dart';

class searchBar extends StatelessWidget {
  void Function(String value) onSubmit;
  double height = 40;
  bool isMarginReq = false;
  double width = 200;
  searchBar({super.key,required this.onSubmit, required this.height, required this.isMarginReq, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: isMarginReq? EdgeInsets.only(left: 20, right: 20, top: 10):null,
      height: height,
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
        onSubmitted: onSubmit,

      ),
    );
  }
}
