import 'package:flutter/material.dart';
import 'package:runo_music/Helper/deviceParams.dart';

class Responsive{

  int smallScreenSize = 580;
  int mediumScreenSize = 1100;

  bool isSmallScreen(context)
  {
    if(getWidth(context)<smallScreenSize) return true;
    return false;
  }

  bool isMediumScreen(context)
  {
    double width = getWidth(context);
    if(width>smallScreenSize && width<mediumScreenSize) return true;
    return false;
  }

  bool isLargeScreen(context)
  {
    double width = getWidth(context);
    if(width>mediumScreenSize) return true;
    return false;
  }

}
