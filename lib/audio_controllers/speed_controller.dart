import 'package:flutter/material.dart';
import 'package:runo_music/Services/Providers/provider.dart';

class SpeedController extends StatelessWidget {
  final void Function(num) onSelected;
  final AudioProvider audioProvider;
  final double? size;
  const SpeedController({super.key ,required this.onSelected, required this.audioProvider, this.size});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: Text("${audioProvider.speed}x", style: TextStyle(color: Colors.white, fontSize: 12),),
        initialValue: audioProvider.speed,
        onSelected: onSelected,
        itemBuilder: (context)
        {
          TextStyle style =  TextStyle(color: Colors.white, fontSize: 15);
          return [
            PopupMenuItem(value:0.5,child: Text("0.5x",style:style,)),
            PopupMenuItem(value:1.0,child: Text("1.0x",style:style,)),
            PopupMenuItem(value:1.5,child: Text("1.5x",style:style,)),
            PopupMenuItem(value:2.0,child: Text("2.0x",style:style,)),
          ];
        }
    );
  }
}
