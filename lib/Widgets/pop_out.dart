import 'package:flutter/material.dart';

import '../Helper/Responsive.dart';

class PopOut extends StatelessWidget {
  final void  Function()? onPress;
  final IconData? icon;
  const PopOut({super.key, this.onPress, this.icon});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 15,
      top: Responsive.isMobile(context) ?40:20,
      child: Container(
        width: 40,
        height: 40,
        decoration: Responsive.isMobile(context) ?  BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(40)):null,
        child: IconButton(
            onPressed: onPress ?? () {
              Navigator.pop(context);
            },
            icon: Icon(color: Colors.white, icon ?? Icons.keyboard_arrow_left)),
      ),
    );
  }
}
