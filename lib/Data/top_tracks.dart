import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Data/fetch_data.dart';


Future<List<List<String>>> FetchTopTracks({required String path,  required PagingController controller, required int pageKey}) async
{
  var trackDetailsJson = await fetchData(
      path: path, limit: '5', offset: '${pageKey * 5}');

  List<List<String>> trackData = [];

  for (int i = 0; i < 5; i++)
  {
    var trackAlbumId = trackDetailsJson['tracks'][i]['albumId'];
    var trackId = trackDetailsJson['tracks'][i]['id'];
    var trackArtistId = trackDetailsJson['tracks'][i]['artistId'];
    var trackArtistName = trackDetailsJson['tracks'][i]['artistName'];
    var trackImageUrl = await fetchData(path: 'albums/$trackAlbumId/images');
    trackData.add([
      trackId,
      trackDetailsJson['tracks'][i]['name'],
      trackImageUrl['images'][3]['url'],
      trackArtistId,
      trackArtistName
    ]);
  }
  return trackData;
}