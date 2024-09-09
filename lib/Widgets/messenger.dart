import 'package:flutter/material.dart';

Widget addedSnackbarContent()
{
  return Container(
    height: 40,
    color: Colors.green,
    child:
    Center(child: Text("Added to favourites")),
  );
}



Widget removedSnackbarContent()
{
  return Container(
    height: 40,
    color: Colors.red,
    child:
    Center(child: Text("Removed from favourites")),
  );
}
