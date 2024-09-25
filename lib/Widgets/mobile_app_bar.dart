import 'package:flutter/material.dart';

PreferredSizeWidget MobileAppBar(BuildContext context, {required bool disablePop, String title=""}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(60),
    child:
    AppBar(
      centerTitle: true,
      title: Text("$title", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 20),),
      leading:
      IconButton(
          onPressed: (){
            if(!disablePop)  Navigator.pop(context);
          },
          icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white,size: 40,)
      ),
      backgroundColor: Colors.white.withOpacity(0.0001),
      actions: [IconButton(
          onPressed: (){
            // Navigator.pop(context);
          },
          icon:const Icon(Icons.more_vert, color: Colors.white,size: 25,)
      ),],
    ),
  );
}
