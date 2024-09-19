import 'package:flutter/material.dart';

import '../Helper/Responsive.dart';

class Header extends StatelessWidget {
  final void Function() onTap;
  final String title;
  const Header({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right:  Responsive.isSmallScreen(context) || Responsive.isMobile(context) ? 20 :(Responsive.isMediumScreen(context)?40:60)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
            padding: EdgeInsets.only(
                left: Responsive.isSmallScreen(context) || Responsive.isMobile(context) ?15 :(Responsive.isMediumScreen(context)?40:60),
            ),
            child: Text(
                title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            InkWell(
              onTap: onTap,
              child: Container(
                  width: 80,
                  height: 35,
                  padding: EdgeInsets.only(
                      top: 5,
                    bottom: 5,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                      child:Text(Responsive.isMobile(context) ? "SEE MORE" : "SEE ALL",
                          style: const TextStyle(color: Colors.white, fontSize: 12))),
              )
            ),
          ]
      ),
    );
  }
}
