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

  // static PlayListModel fromJson(Map<String, dynamic> json) => PlayListModel(
  //   name: json["name"],
  //   imageUrl : json["imageURl"],
  //   trackId: List<String>.from(json["trackId"].map((x) => x)),
  // );

  static PlayListModel fromJson(Map<String, dynamic> json) => PlayListModel(
    name: json["name"] ?? '',
    imageUrl: json["imageUrl"] ?? '',
    trackId: json["trackId"] != null
        ? List<String>.from(json["trackId"].map((x) => x.toString())) // Ensure each item is a string
        : [], // Fallback if trackId is null
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "imageUrl": imageUrl,
    "trackId": List<dynamic>.from(trackId.map((x) => x)),
  };
}
