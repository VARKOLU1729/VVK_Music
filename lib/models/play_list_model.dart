import 'package:runo_music/models/track_model.dart';

class PlayListModel
{
  String name;
  String imageUrl;
  List<TrackModel> tracks = [];
  PlayListModel({ required this.name, required this.imageUrl});
}
