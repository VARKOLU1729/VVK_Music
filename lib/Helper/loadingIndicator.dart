import 'package:flutter/material.dart';


Widget loadingIndicator()
{
  return Center(
    child: SizedBox(
      height: 40,
      width: 40,
      child: CircularProgressIndicator(color: Color.fromARGB(255, 37, 209, 218),),
    ),
  );
}
