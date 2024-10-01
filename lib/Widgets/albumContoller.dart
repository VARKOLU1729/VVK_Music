import 'package:flutter/material.dart';

import '../Helper/noFunctionality.dart';

Widget iconButton({required context, required icon, required onPressed})
{
  return IconButton(onPressed: onPressed, icon: Icon(icon, color: Colors.white,));
}