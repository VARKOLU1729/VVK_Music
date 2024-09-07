import 'package:flutter/material.dart';

class popOut extends StatelessWidget {
  const popOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(40)),
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(color: Colors.white, Icons.keyboard_arrow_down)),
      ),
      left: 15,
      top: 40,
    );
  }
}
