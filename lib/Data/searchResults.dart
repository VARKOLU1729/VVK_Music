import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<List<dynamic>>> FetchSearchTracks({required String path,required String Query,  required PagingController controller, required int pageKey}) async
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
  print(trackDetailsJson);
  List<List<dynamic>> trackData = [];

  for (int i = 0; i < 5; i++)
  {
    var trackAlbumId = trackDetailsJson['tracks'][i]['albumId'];
    var trackId = trackDetailsJson['tracks'][i]['id'];
    var trackName = trackDetailsJson['tracks'][i]['name'];
    var trackArtistId = trackDetailsJson['tracks'][i]['artistId'];
    var trackArtistName = trackDetailsJson['tracks'][i]['artistName'];
    var trackImageUrl = await fetchData(path: 'albums/$trackAlbumId/images');
    var trackAlbumName = trackDetailsJson['tracks'][i]['albumName'];
    trackData.add([
      trackId,
      trackName,
      trackImageUrl['images'][3]['url'],
      trackArtistId,
      trackArtistName,
      trackAlbumId,
      trackAlbumName
    ]);
  }
  return trackData;
}