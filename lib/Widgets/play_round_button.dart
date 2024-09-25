import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Widgets/provider.dart';

import '../Views/music_player_view.dart';

class PlayRoundButton extends StatelessWidget {

  final List<dynamic> items;
  const PlayRoundButton({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    var audioProvider = Provider.of<AudioProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Theme.of(context).colorScheme.tertiary
      ),
      child: IconButton(onPressed: () async{

        if(items.isEmpty)
        {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor:Colors.orangeAccent, content: Text("No items to Play!", style: TextStyle(color: Colors.white),)));
        }
        else
        {
          await audioProvider.loadAudio(trackList: items, index: 0);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MusicPlayerView()),);
        }

      }, icon: const Icon(Icons.play_arrow, size: 30,color: Colors.black,)),
    );
  }
}
