import 'package:runo_music/models/track_model.dart';

class PlayListModel {
  String name;
  String imageUrl;
  List<String> trackId;

  PlayListModel({
    required this.name,
    required this.imageUrl,
    List<String>? trackId,
  }) : trackId = trackId ?? [];

  PlayListModel fromJson(Map<String, dynamic> json) => PlayListModel(
    name: json["name"],
    imageUrl : json["imageURl"],
    trackId: List<String>.from(json["trackId"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "imageUrl": imageUrl,
    "trackId": List<dynamic>.from(trackId.map((x) => x)),
  };
}
