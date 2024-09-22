import 'package:flutter/material.dart';

import '../Helper/Responsive.dart';

class Header extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final ScrollController? scrollController;
  const Header({super.key, required this.onTap, required this.title,this.scrollController});

  void leftScroll(ScrollController scrollController)
  {
    scrollController.animateTo(
        scrollController.offset-500,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void rightScroll(ScrollController scrollController)
  {
    scrollController.animateTo(
        scrollController.offset+500,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

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

            SizedBox(
              width: Responsive.isMobile(context)?80: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(!Responsive.isMobile(context))
                  IconButton(onPressed: ()=>leftScroll(scrollController!), icon:Icon(Icons.keyboard_arrow_left, color: Colors.white,)),
                  if(!Responsive.isMobile(context))
                  IconButton(onPressed: ()=>rightScroll(scrollController!), icon:Icon(Icons.keyboard_arrow_right, color: Colors.white,)),
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
                ],
              ),
            ),

            // InkWell(
            //   onTap: onTap,
            //   child: Container(
            //       width: 80,
            //       height: 35,
            //       padding: EdgeInsets.only(
            //           top: 5,
            //         bottom: 5,
            //       ),
            //       decoration: BoxDecoration(
            //           color: Colors.grey.withOpacity(0.1),
            //           borderRadius: BorderRadius.circular(50)),
            //       child: Center(
            //           child:Text(Responsive.isMobile(context) ? "SEE MORE" : "SEE ALL",
            //               style: const TextStyle(color: Colors.white, fontSize: 12))),
            //   )
            // ),
          ]
      ),
    );
  }
}
