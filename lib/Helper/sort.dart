import '../models/track_model.dart';

void sortTracks(List<TrackModel> tracks, {required String sortBy}) {
  tracks.sort((a, b) {
    if(sortBy=='trackName') return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    else if(sortBy=='artistName') return a.artistName.toLowerCase().compareTo(b.artistName.toLowerCase());
    else if(sortBy=='albumName') return a.albumName.toLowerCase().compareTo(b.albumName.toLowerCase());
    else return 0;
  });
}
