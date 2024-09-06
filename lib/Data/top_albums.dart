import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Data/fetch_data.dart';


Future<List<List<String>>> FetchTopAlbums({required String path,required PagingController controller, required int pageKey}) async
{
  var albumDetailsJson = await fetchData(
      path: path, limit: '5', offset: '${pageKey * 5}');

  List<List<String>> albumData = [];

  for (int i = 0; i < 5; i++)
  {
    var albumId = albumDetailsJson['albums'][i]['id'];
    var albumName = albumDetailsJson['albums'][i]["name"];
    var albumImageUrl = await fetchData(path: 'albums/$albumId/images');
    var albumArtistId =
    albumDetailsJson['albums'][i]['contributingArtists']['mainArtist'];
    var albumArtistName = albumDetailsJson['albums'][i]['artistName'];
    albumData.add([
      albumId,
      albumName,
      albumImageUrl['images'][3]['url'],
      albumArtistId,
      albumArtistName,
      albumId,
      albumName
    ]);
  }
  return albumData;
}