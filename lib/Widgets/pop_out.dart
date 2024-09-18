import 'package:flutter/material.dart';

class PopOut extends StatelessWidget {
  final void  Function()? onPress;
  final IconData? icon;
  const PopOut({super.key, this.onPress, this.icon});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 15,
      top: 40,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(40)),
        child: IconButton(
            onPressed: onPress ?? () {
              Navigator.pop(context);
            },
            icon: Icon(color: Colors.white, icon ?? Icons.keyboard_arrow_left)),
      ),
    );
  }
}
