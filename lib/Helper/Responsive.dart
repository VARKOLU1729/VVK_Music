import 'package:flutter/material.dart';
import 'package:runo_music/Helper/deviceParams.dart';

class Responsive{

  static int smallScreenSize = 700;
  static int mediumScreenSize = 1100;

  static bool isSmallScreen(context)
  {
    if(getWidth(context)<=smallScreenSize) return true;
    return false;
  }

  static bool isMediumScreen(context)
  {
    double width = getWidth(context);
    if(width>smallScreenSize && width<=mediumScreenSize) return true;
    return false;
  }

  static bool isLargeScreen(context)
  {
    double width = getWidth(context);
    if(width>mediumScreenSize) return true;
    return false;
  }

}
