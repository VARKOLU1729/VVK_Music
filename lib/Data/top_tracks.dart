import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:runo_music/models/track_model.dart';


Future<List<dynamic>> FetchTopTracks({required String path,  required PagingController controller, required int pageKey}) async
{
  List<TrackModel> tracks = [];
  try
  {
    var trackDetailsJson = await fetchData(path: path, limit: '5', offset: '${pageKey * 5}');
    for(int i=0; i<5; i++)
      {
        var track = await TrackModel.fromJson(trackDetailsJson['tracks'][i]) ;
        tracks.add(track);
      }
  }
  catch(error)
  {
    controller.error = error;
  }
  finally
      {
        return tracks;
      }



  // List<List<dynamic>> trackData = [];
  //
  // for (int i = 0; i < 5; i++)
  // {
  //   var trackAlbumId = trackDetailsJson['tracks'][i]['albumId'];
  //   var trackId = trackDetailsJson['tracks'][i]['id'];
  //   var trackName = trackDetailsJson['tracks'][i]['name'];
  //   var trackArtistId = trackDetailsJson['tracks'][i]['artistId'];
  //   var trackArtistName = trackDetailsJson['tracks'][i]['artistName'];
  //   var trackImageUrl = await fetchData(path: 'albums/$trackAlbumId/images');
  //   var trackAlbumName = trackDetailsJson['tracks'][i]['albumName'];
  //   trackData.add([
  //     trackId,
  //     trackName,
  //     trackImageUrl['images'][3]['url'],
  //     trackArtistId,
  //     trackArtistName,
  //     trackAlbumId,
  //     trackAlbumName
  //   ]);
  // }
  // return trackData;
}