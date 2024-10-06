import 'package:flutter/material.dart';
import 'dart:ui';
class BackGroundBlur extends StatelessWidget {
  const BackGroundBlur({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        blendMode: BlendMode.src,
        filter: ImageFilter.blur(sigmaX: 100, sigmaY:100),
        child: Container(
          color: Colors.black87.withOpacity(0.5),
        ),
      ),
    );
  }
}
