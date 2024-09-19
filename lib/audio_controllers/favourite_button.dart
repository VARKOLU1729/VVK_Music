import 'package:flutter/material.dart';

class favButton extends StatelessWidget {
  final void Function() onTap;
  final bool addedToFav;
  const favButton({super.key, required this.onTap, required this.addedToFav});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        Icons.favorite,
        color: addedToFav ? const Color.fromARGB(255, 12, 189, 189) : Colors.white,
      ),
    );
  }
}
