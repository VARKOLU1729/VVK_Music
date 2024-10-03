import 'package:flutter/material.dart';
import 'package:runo_music/Helper/deviceParams.dart';
import 'package:toastification/toastification.dart';
import 'Responsive.dart';

void showMessage({required BuildContext context, required String content})
{
  if(Responsive.isMobile())
    {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: Color.fromARGB(255, 15, 119, 142)
              )
            ),
            backgroundColor: Color.fromARGB(255, 6, 31,33).withOpacity(1),
             width: 200,
              content: Center(child: Text("$content", style: TextStyle(color: Colors.white),))
          )
      );
    }
  else
    {
      toastification.show(
        context: context,
        type: ToastificationType.info,
        autoCloseDuration: Duration(seconds: 1),
        title: Text("$content"),
        style: ToastificationStyle.flatColored,

      );
    }
}

