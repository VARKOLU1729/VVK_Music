import 'package:flutter/material.dart';

class bottomIcon extends StatelessWidget {
  final Widget icon;
  const bottomIcon({super.key,required this.icon,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      child:  icon ,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.grey.withOpacity(0.44),
            Colors.grey.withOpacity(0.22),
          ],
        ),
        color: Colors.red,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
