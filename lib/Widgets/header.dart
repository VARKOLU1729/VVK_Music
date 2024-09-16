import 'package:flutter/material.dart';

import '../Helper/Responsive.dart';

class Header extends StatelessWidget {
  void Function() onTap;
  String title;
  Header({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
            padding: EdgeInsets.only(left: Responsive.isSmallScreen(context) ?15 :(Responsive.isMediumScreen(context)?40:60)),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            ),
            InkWell(
              onTap: onTap,
              child: Container(
                  width: 100,
                  height: 25,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                      child: Text("SEE MORE",
                          style: TextStyle(color: Colors.white)))),
            ),
          ]
      ),
    );
  }
}
