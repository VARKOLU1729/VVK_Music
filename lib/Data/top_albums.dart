import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:runo_music/models/album_model.dart';


Future<List<dynamic>> FetchTopAlbums({required String path,required PagingController controller, required int pageKey}) async
{

    List<AlbumModel> albums = [];
    try
    {
      var albumDetailsJson = await fetchData(path: path, limit: '5', offset: '${pageKey * 5}');
      for(int i=0; i<5; i++)
      {
        var album = await AlbumModel.fromJson(albumDetailsJson['albums'][i]);
        albums.add(album);
      }
    }
    catch(error)
    {
      controller.error = error;
    }
    finally
    {
      return albums;
    }

}