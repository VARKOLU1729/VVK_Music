import 'package:flutter/material.dart';

import '../Views/profile_view.dart';
import '../tab_screen.dart';

PreferredSizeWidget MobileAppBar2(BuildContext context, {String title=""}) {
  return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child:
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: AppBar(
            centerTitle: true,
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 20),),
            leading:IconButton(
              onPressed: (){},
              icon: const Icon(Icons.notifications, color: Colors.white,size: 30,)
              ),
            backgroundColor: Colors.transparent,
            actions: [IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>TabScreen(activePage: ProfileView(),)));
              },
              icon:const Icon(Icons.person, color: Colors.white,size: 30,)
            ),
            ],
              )
          )
  );
}