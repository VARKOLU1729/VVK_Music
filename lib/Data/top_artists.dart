import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:runo_music/Data/fetch_data.dart';
import 'package:runo_music/models/artist_model.dart';


Future<List<dynamic>> FetchTopArtists({required String path,required PagingController controller, required int pageKey}) async
{

  List<ArtistModel> artists = [];
  try
  {
    var artistDetailsJson = await fetchData(path: path, limit: '5', offset: '${pageKey * 5}');
    for(int i=0; i<5; i++)
    {
      var artist = await ArtistModel.fromJson(artistDetailsJson['artists'][i]);
      artists.add(artist);
    }
  }
  catch(error)
  {
    controller.error = error;
  }
  finally
  {
    return artists;
  }

}