import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Helper/Responsive.dart';
import 'package:runo_music/Services/Providers/provider.dart';

import '../Views/music_player_view.dart';

class PlayTextButton extends StatelessWidget {
  final List<dynamic> trackList;

  const PlayTextButton({super.key, required this.trackList});

  @override
  Widget build(BuildContext context) {
    var audioProvider = Provider.of<AudioProvider>(context, listen: false);
    return Container(
      width: 90,
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Responsive.isMobile() ? Theme.of(context).colorScheme.secondary.withOpacity(0.5) : Theme.of(context).colorScheme.tertiary
      ),
      child: TextButton(onPressed: () async{
        if(trackList.isEmpty)
        {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(duration: Duration(milliseconds: 30), backgroundColor:Colors.orangeAccent, content: Text("No items to Play!", style: TextStyle(color: Colors.white),)));
        }
        else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MusicPlayerView()),);
          await audioProvider.loadAudio(trackList: trackList, index: 0);
        }
      }, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [Icon(Icons.play_arrow,size: 30, color: Responsive.isMobile()? Colors.white : Colors.black87,), Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Text('Play', style: TextStyle(color: Responsive.isMobile()? Colors.white : Colors.black87),),
      )],)),
    );
  }
}
