import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ScaffoldFeatureController noFunctionality(BuildContext context)
{
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration:const Duration(milliseconds: 30),
          content: Container(
            height: 40,
            color: Colors.lightGreen,
            child: Center(child: Text("No functionality exists"),),
          )
      ));
}
