import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/track_model.dart';

Future<List<dynamic>> FetchSearchTracks({required String path,required String Query,  required PagingController controller, required int pageKey}) async
{
  List<TrackModel> tracks = [];
  try
  {
    var url = Uri(
        scheme: 'https',
        host: 'api.napster.com',
        path: 'v2.2/${path}',
        queryParameters: {
          'query' : Query,
          'per_type_limit': '5',
          'offset': '5',
          'apikey': "OTYxNDY3NTItZmM1Zi00MTMzLTllN2UtMDk2ZTBlMzIyYTZm"
        });
    var res = await http.get(url);
    var DetailsJson = json.decode(res.body);
    var trackDetailsJson = DetailsJson['search']['data'];
    for(int i=0; i<5; i++)
    {
      var track = await TrackModel.fromJson(trackDetailsJson['tracks'][i]) ;
      tracks.add(track);
    }
    return tracks;
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