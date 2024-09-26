import 'package:runo_music/Services/Data/fetch_data.dart';

class TrackModel
{
  final String id;
  final String name;
  final String artistId;
  final String artistName;
  final String albumId;
  final String albumName;
  final String imageUrl;

  TrackModel({
    required this.id,
    required this.name,
    required this.artistId,
    required this.artistName,
    required this.albumId,
    required this.albumName,
    required this.imageUrl,
  });

  static Future<TrackModel> fromJson(Map<String, dynamic> json) async {
    final trackAlbumId = json['albumId'];
    final trackImageUrl = await fetchData(path: 'albums/$trackAlbumId/images');

    return TrackModel(
      id: json['id'],
      name: json['name'],
      imageUrl: trackImageUrl['images'][3]['url'],
      artistId: json['artistId'],
      artistName: json['artistName'],
      albumId: trackAlbumId,
      albumName: json['albumName'],
    );
  }

}