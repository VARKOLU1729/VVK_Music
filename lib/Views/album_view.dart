import 'package:flutter/material.dart';
import 'package:runo_music/Widgets/back_ground_blur.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:runo_music/Widgets/pop_out.dart';
import 'package:runo_music/Widgets/list_all.dart';
import 'package:runo_music/models/track_model.dart';

List<TrackModel> albumTrackData = [];

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

  //paging option is not there , so directly fetched all the results
  void _loadData() async {
    List<TrackModel> albumTrackDat = [];
    var albumTracksJson =  await fetchData(path: '/albums/${widget.albumId}/tracks');
    var noAlbumTracks = albumTracksJson['meta']['returnedCount'];
    for (int i = 0; i < noAlbumTracks; i++) {

      var track = await TrackModel.fromJson(albumTracksJson['tracks'][i]) ;
      albumTrackDat.add(track);
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
                    colors: [Colors.black.withOpacity(0.005), Colors.black.withOpacity(0.05), Colors.black.withOpacity(0.2),  Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.4),Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.9)]
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
                        return ListAllWidget(index: index,items: albumTrackData);

                      }))
            ],
          ),
        ]));
  }
}
