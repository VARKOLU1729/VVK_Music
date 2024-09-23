import 'package:flutter/foundation.dart';
import 'package:runo_music/Helper/deviceParams.dart';
// platform specific checks
class Responsive{

  static int smallScreenSize = 620;
  static int mediumScreenSize = 1200;


  static bool isMobile([context])
  {
    return !kIsWeb;
  }

  static bool isSmallScreen(context)
  {
    if(kIsWeb && getWidth(context)<=smallScreenSize) return true;
    return false;
  }

  static bool isMediumScreen(context)
  {
    double width = getWidth(context);
    if(kIsWeb && width>smallScreenSize && width<=mediumScreenSize) return true;
    return false;
  }

  static bool isLargeScreen(context)
  {
    double width = getWidth(context);
    if(kIsWeb && width>mediumScreenSize) return true;
    return false;
  }

}
