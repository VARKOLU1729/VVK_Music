import 'package:flutter/material.dart';
import 'package:runo_music/Widgets/back_ground_blur.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:runo_music/Views/music_player_view.dart';
import 'package:runo_music/Widgets/pop_out.dart';
import 'package:runo_music/Widgets/pop_out.dart';

class AlbumView extends StatefulWidget {
  final String albumId;
  final String albumName;
  final String albumImageUrl;
  final String artistId;
  final String artistName;
  const AlbumView(
      {super.key,
      required this.albumId,
      required this.albumName,
      required this.albumImageUrl,
      required this.artistId,
      required this.artistName});

  @override
  State<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  List<List<String>> albumTrackData = [];

  //paging option is not there , so directlt fetched all the results
  void _loadData() async {
    List<List<String>> albumTrackDat = [];
    var albumTracksJson =
        await fetchData(path: '/albums/${widget.albumId}/tracks');
    var noAlbumTracks = albumTracksJson['meta']['returnedCount'];
    for (int i = 0; i < noAlbumTracks; i++) {
      var albumTrackId = albumTracksJson['tracks'][i]['id'];
      var albumTrackName = albumTracksJson['tracks'][i]['name'];
      albumTrackDat.add([
        albumTrackId,
        albumTrackName,
        widget.albumImageUrl,
        widget.artistId,
        widget.artistName
      ]);
      // print(albumTrackData);
    }
    setState(() {
      albumTrackData = albumTrackDat;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(200, 9, 3, 3),
        body: Stack(children: [
          Image.network(
            widget.albumImageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
      BackGroundBlur(),
      popOut(),
      Column(
        children: [
          Container(
            height: 300,
            child: ImageContainer(albumImageUrl: widget.albumImageUrl),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: albumTrackData.length,
                  itemBuilder: (context, index) {
                    return AlbumTrackWidget(
                      albumTrackId: albumTrackData[index][0],
                      albumTrackName: albumTrackData[index][1],
                      albumImageUrl: albumTrackData[index][2],
                      artistId: albumTrackData[index][3],
                      artistName: albumTrackData[index][4],
                    );
                  }
                  )
          )
        ],
      ),
    ])

    );
  }
}

class ImageContainer extends StatelessWidget {
  final String albumImageUrl;
  const ImageContainer({super.key, required this.albumImageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Image.network(
          scale: 1,
          albumImageUrl,
        ),
      ),
    );
  }
}

class AlbumTrackWidget extends StatelessWidget {
  final String albumTrackId;
  final String albumTrackName;
  final String albumImageUrl;
  final String artistId;
  final String artistName;
  const AlbumTrackWidget(
      {super.key,
      required this.albumTrackId,
      required this.albumTrackName,
      required this.albumImageUrl,
      required this.artistId,
      required this.artistName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print(albumTrackId);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MusicPlayerView(
                trackId: albumTrackId,
                trackName: albumTrackName,
                trackImageUrl: albumImageUrl,
                artistId: artistId,
                artistName: artistName),
          ));
        },
        child: ListTile(
          tileColor: Colors.black,
          selectedTileColor: Colors.pink,
          leading: Icon(Icons.music_note),
          title: Text(
            albumTrackName,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          trailing: Icon(Icons.favorite),
        ));
  }
}
