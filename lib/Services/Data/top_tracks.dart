import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Services/Data/fetch_data.dart';
import 'package:runo_music/models/track_model.dart';


Future<List<dynamic>> FetchTopTracks({required String path, PagingController? controller, required int pageKey, int limit=5}) async
{
  List<TrackModel> tracks = [];
  try
  {
    var trackDetailsJson = await fetchData(path: path, limit: '$limit', offset: '${pageKey * 5}');
    for(int i=0; i<5; i++)
      {
        var track = await TrackModel.fromJson(trackDetailsJson['tracks'][i]) ;
        tracks.add(track);
      }
  }
  catch(error)
  {
    if(controller!=null)
    controller.error = error;
  }
  finally
      {
        return tracks;
      }


}