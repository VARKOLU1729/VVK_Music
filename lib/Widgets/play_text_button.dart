import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Widgets/provider.dart';

import '../Views/music_player_view.dart';

class PlayTextButton extends StatelessWidget {
  final List<dynamic> trackList;

  const PlayTextButton({super.key, required this.trackList});

  @override
  Widget build(BuildContext context) {
    var audioProvider = Provider.of<AudioProvider>(context, listen: false);
    return Container(
      width: 90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromARGB(255, 11, 228, 228)
      ),
      child: TextButton(onPressed: () async{
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MusicPlayerView()),);
        await audioProvider.loadAudio(trackList:trackList,index:0);

      }, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [Icon(Icons.play_arrow, color: Colors.black87,), Text('Play', style: TextStyle(color: Colors.black87),)],)),
    );
  }
}
