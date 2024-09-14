import 'package:flutter/material.dart';

import '../Data/fetch_data.dart';

class AlbumModel
{
  final String id;
  final String name;
  final String imageUrl;
  final String artistId;
  final String artistName;

  AlbumModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.artistId,
    required this.artistName,
  });

  static Future<AlbumModel> fromJson(Map<String, dynamic> json) async {
    final albumId = json['id'];
    final albumImageUrl = await fetchData(path: 'albums/$albumId/images');

    return AlbumModel(
      id: json['id'],
      name: json['name'],
      imageUrl: albumImageUrl['images'][3]['url'],
      artistId: json['contributingArtists']['mainArtist'],
      artistName: json['artistName'],
    );
  }

}