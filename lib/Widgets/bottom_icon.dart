import 'package:flutter/material.dart';

class bottomIcon extends StatelessWidget {
  final Widget icon;
  const bottomIcon({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: icon,
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
