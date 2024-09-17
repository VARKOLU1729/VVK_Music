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


}