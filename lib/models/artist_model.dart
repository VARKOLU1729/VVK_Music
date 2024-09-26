import 'package:runo_music/Services/Data/fetch_data.dart';

class ArtistModel
{
  final String id;
  final String name;
  final String imageUrl;

  ArtistModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  static Future<ArtistModel> fromJson(Map<String, dynamic> json) async {
    final artistId = json['id'];
    final artistImageUrl = await fetchData(path: '/artists/${artistId}/images');

    return ArtistModel(
      id: json['id'],
      name: json['name'],
      imageUrl: artistImageUrl['images'][1]['url'],
    );
  }
}