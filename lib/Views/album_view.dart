import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Widgets/back_ground_blur.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:runo_music/Views/music_player_view.dart';
import 'package:runo_music/Widgets/pop_out.dart';
import 'package:runo_music/Widgets/pop_out.dart';

List<List<dynamic>> albumTrackData = [];

class AlbumView extends StatefulWidget {
  final String albumId;
  final String albumName;
  final String albumImageUrl;
  final String artistId;
  final String artistName;
  final void Function(List<dynamic> item) addToFavourite;

  const AlbumView(
      {super.key,
      required this.albumId,
      required this.albumName,
      required this.albumImageUrl,
      required this.artistId,
      required this.artistName,
      required this.addToFavourite});


  @override
  State<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {

  //paging option is not there , so directly fetched all the results
  void _loadData() async {
    List<List<dynamic>> albumTrackDat = [];
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
        widget.artistName,
        widget.albumId,
        widget.albumName
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
          Container(
            margin: EdgeInsets.only(top: 300),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.05), Colors.black.withOpacity(0.3),Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.9)]
                )
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 1,
                child:
                Center(
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                      Image.network(
                        widget.albumImageUrl,
                        fit: BoxFit.cover,
                        // scale: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                  child: ListView.builder(
                      itemCount: albumTrackData.length,
                      itemBuilder: (context, index) {
                        return AlbumTrackWidget(
                          index:index,
                          albumTrackId: albumTrackData[index][0],
                          albumTrackName: albumTrackData[index][1],
                          albumImageUrl: albumTrackData[index][2],
                          artistId: albumTrackData[index][3],
                          artistName: albumTrackData[index][4],
                          albumId: widget.albumId,
                          albumName: widget.albumName,
                          addToFavourite: widget.addToFavourite,
                        );
                      }))
            ],
          ),
        ]));
  }
}

class AlbumTrackWidget extends StatefulWidget {
  final int index;
  final String albumTrackId;
  final String albumTrackName;
  final String albumImageUrl;
  final String artistId;
  final String artistName;
  final String albumId;
  final String albumName;
  final void Function(List<dynamic> item) addToFavourite;


  AlbumTrackWidget(
      {super.key,
        required this.index,
        required this.albumTrackId,
        required this.albumTrackName,
        required this.albumImageUrl,
        required this.artistId,
        required this.artistName,
        required this.albumId,
        required this.addToFavourite,
        required this.albumName
      });

  @override
  State<AlbumTrackWidget> createState() => _AlbumTrackWidgetState();
}

class _AlbumTrackWidgetState extends State<AlbumTrackWidget> {
  bool addedToFav = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MusicPlayerView(
              items: albumTrackData,
              index: widget.index,
              addToFavourite:  widget.addToFavourite,
            ),
          ));
        },
        child: ListTile(
          tileColor: Colors.black,
          selectedTileColor: Colors.pink,
          leading: Icon(Icons.music_note_sharp, color: Colors.blue,),
          title: Text(
            widget.albumTrackName,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          trailing: IconButton(
            icon:Icon(Icons.favorite, color:addedToFav?Colors.red:Colors.white),
            onPressed: (){
              widget.addToFavourite([widget.index,0, albumTrackData]);
              setState(() {
                addedToFav = !addedToFav;
                //add remove to fav here - if time is sufficient
              });
            },),
        ));;
  }
}


// class AlbumTrackWidget extends StatelessWidget {
//   final String albumTrackId;
//   final String albumTrackName;
//   final String albumImageUrl;
//   final String artistId;
//   final String artistName;
//   final void Function(List<String> item) addToFavourite;
//   bool addedToFav = false;
//
//   AlbumTrackWidget(
//       {super.key,
//       required this.albumTrackId,
//       required this.albumTrackName,
//       required this.albumImageUrl,
//       required this.artistId,
//       required this.artistName,
//       required this.addToFavourite});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: () {
//           print(albumTrackId);
//           Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => MusicPlayerView(
//               trackId: albumTrackId,
//               trackName: albumTrackName,
//               trackImageUrl: albumImageUrl,
//               artistId: artistId,
//               artistName: artistName,
//               addToFavourite: addToFavourite,
//             ),
//           ));
//         },
//         child: ListTile(
//           tileColor: Colors.black,
//           selectedTileColor: Colors.pink,
//           leading: Icon(Icons.music_note_sharp, color: Colors.blue,),
//           title: Text(
//             albumTrackName,
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           trailing: IconButton(
//             icon:Icon(Icons.favorite),
//             onPressed: (){
//               addToFavourite([albumTrackId,albumTrackName,albumImageUrl, artistId, artistName]);
//               setState(() {
//                 addedToFav = !addedToFav;
//                 //add remove to fav here - if time is sufficient
//               });
//               },),
//         ));
//   }
// }
