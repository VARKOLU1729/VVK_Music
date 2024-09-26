import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:runo_music/Views/search.dart';

import 'package:runo_music/Services/Data/fetch_data.dart';
import 'package:runo_music/Services/Data/top_tracks.dart';
import 'package:runo_music/Services/Data/top_albums.dart';

import '../Helper/deviceParams.dart';
import '../Helper/Responsive.dart';

import '../Widgets/track_album_widget.dart';
import '../Widgets/header.dart';
import '../Widgets/pop_out.dart';
import '../Widgets/display_with_pagination.dart';
import '../Widgets/see_all.dart';
import '../Services/Providers/provider.dart';

import '../Views/music_player_view.dart';

class ArtistView extends StatefulWidget {

  final String artistId;
  const ArtistView({super.key, required this.artistId});

  @override
  State<ArtistView> createState() => _ArtistViewState();
}

class _ArtistViewState extends State<ArtistView> {
  String? artistImageUrl;
  String? artistName;
  String? artistBio;
  final PagingController<int, dynamic> _artistTrackPagingController = PagingController(firstPageKey: 0);
  final PagingController<int, dynamic> _artistAlbumPagingController = PagingController(firstPageKey: 0);

  final ScrollController trackScrollController = ScrollController();
  final ScrollController albumScrollController = ScrollController();
  final ScrollController artistScrollController = ScrollController();

  void _loadTrackData(pageKey) async {
    List<dynamic> trackData = await FetchTopTracks(
        path: 'artists/${widget.artistId}/tracks/top',
        controller: _artistTrackPagingController,
        pageKey: pageKey);
    _artistTrackPagingController.appendPage(trackData, pageKey + 1);
  }

  void _loadAlbumData(pageKey) async {
    List<dynamic> albumData = await FetchTopAlbums(
        path: 'artists/${widget.artistId}/albums/top',
        controller: _artistAlbumPagingController,
        pageKey: pageKey);
    _artistAlbumPagingController.appendPage(albumData, pageKey + 1);
  }

  void _loadArtistData() async {
    var artistData = await fetchData(path: 'artists/${widget.artistId}');
    setState(() {
      artistBio = artistData['artists'][0]['bios'][0]['bio'];
      artistName = artistData['artists'][0]['name'];
    });
  }

  void _loadImage() async {
    var imageUrl = await fetchData(path: '/artists/${widget.artistId}/images');
    setState(() {
      artistImageUrl = imageUrl['images'][1]['url'];
    });
  }

  @override
  void initState() {
    super.initState();
    _artistTrackPagingController.addPageRequestListener((pageKey) {
      _loadTrackData(pageKey);
    });
    _artistAlbumPagingController.addPageRequestListener((pageKey) {
      _loadAlbumData(pageKey);
    });
    _loadArtistData();
    _loadImage();
  }

  @override
  void dispose() {
    _artistTrackPagingController.dispose();
    _artistAlbumPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:Responsive.isMobile(context) ?AppBar(backgroundColor: Colors.black87,toolbarHeight: 5,):null,
        backgroundColor: Colors.black87,
        body: Stack(
          children: [
            Column(children: [
              if(!Responsive.isMobile()) SizedBox(height: 72,),
              (Responsive.isMobile(context) || Responsive.isSmallScreen(context))?
                Expanded(
                  flex: 2,
                  child:Container(
                    height: getHeight(context) / 3.25,
                    decoration: artistImageUrl == null
                        ? null
                        : BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(artistImageUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // The ListTile with the gradient overlay applied only to the bottom
                        Positioned(
                          bottom: 0, // Ensures it stays at the bottom
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.05),
                                  Colors.black.withOpacity(0.1),
                                  Colors.black.withOpacity(0.2),
                                ],
                              ),
                            ),
                            child: ListTile(
                              title: artistName == null
                                  ? const CircularProgressIndicator()
                                  : Text(
                                artistName!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              subtitle: const Text(
                                "6L Monthly Listeners",
                                style: TextStyle(color: Colors.white70),
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.red.withOpacity(0.66),
                                      Colors.red.withOpacity(0.99),
                                    ],
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    final audioProvider = Provider.of<AudioProvider>(
                                      context,
                                      listen: false,
                                    );
                                    await audioProvider.loadAudio(
                                      trackList: _artistTrackPagingController.itemList!,
                                      index: 0,
                                    );
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const MusicPlayerView(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ):
                Expanded(
                    flex: 3,
                    child: Stack(
                      children: [

                        SizedBox(
                          width: double.infinity,
                          child:ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: artistImageUrl == null
                                ? null
                                : Image.network(artistImageUrl!, fit: BoxFit.cover,),
                          ),
                        ),

                        BackdropFilter(
                          blendMode: BlendMode.src,
                          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                          child: Container(
                            color: Colors.black87.withOpacity(0.001),
                          ),
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 60),
                              child: SizedBox(
                                width: getWidth(context)<700 ? 300 : 400,
                                height: getWidth(context)<700 ? 500 : 600,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20, top: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: artistImageUrl == null
                                        ? null
                                        : Image.network(artistImageUrl!, fit: BoxFit.cover,),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Column(
                                  crossAxisAlignment : CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: artistName == null
                                          ? const CircularProgressIndicator()
                                          : Text(
                                              artistName!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Responsive.isSmallScreen(context) ? 30 : (Responsive.isMediumScreen(context) ? 40 : 50)),
                                            ),
                                      subtitle: Text(
                                        "6L Monthly Listeners",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: Responsive.isSmallScreen(context) ? 10 : (Responsive.isMediumScreen(context) ? 15 : 20)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.red.withOpacity(0.66),
                                                  Colors.red.withOpacity(0.99)
                                                ])),
                                        child: IconButton(
                                            onPressed: () async {
                                              final audioProvider = Provider.of<AudioProvider>(context, listen: false);
                                              await audioProvider.loadAudio(trackList: _artistTrackPagingController.itemList!, index: 0);
                                              Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context) => const MusicPlayerView()),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.play_arrow,
                                              size: Responsive.isSmallScreen(context) ? 30 : (Responsive.isMediumScreen(context) ? 40 : 60),
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),


              const SizedBox(
                height: 40,
              ),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Header(
                          // onTap: () {
                          //   Widget widget = SeeAll(
                          //       type: Type.track,
                          //       pagingController: _artistTrackPagingController);
                          //   if (Responsive.isSmallScreen(context))
                          //     {
                          //       showModalBottomSheet(
                          //         useSafeArea: true,
                          //           constraints: BoxConstraints(
                          //               minHeight: getHeight(context)),
                          //           context: context,
                          //           builder: (context) => widget);
                          //     }
                          //   else {
                          //     Navigator.of(context).push(MaterialPageRoute(
                          //         builder: (context) => widget));
                          //   }
                          // },
                        type: Type.track,
                          pagingController: _artistTrackPagingController,
                          title: "Top Tracks",
                        scrollController: trackScrollController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DisplayWithPagination(
                          pagingController: _artistTrackPagingController,
                          type: Type.track,
                          scrollController: trackScrollController
                      ),
                      Header(
                          // onTap: () {
                          //   Widget widget = SeeAll(
                          //       type: Type.album,
                          //       pagingController: _artistAlbumPagingController);
                          //   if (Responsive.isSmallScreen(context))
                          //     {
                          //       showModalBottomSheet(
                          //         useSafeArea: true,
                          //           context: context,
                          //           builder: (context) => widget);
                          //     }
                          //
                          //   else {
                          //     Navigator.of(context).push(MaterialPageRoute(
                          //         builder: (context) => widget));
                          //   }
                          // },
                        pagingController: _artistAlbumPagingController,
                          type: Type.album,
                          title: "Top Albums",
                          scrollController: albumScrollController
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      DisplayWithPagination(
                          pagingController: _artistAlbumPagingController,
                          type: Type.album,
                          scrollController: albumScrollController
                      ),

                      (artistName == null ||
                              artistBio == null ||
                              artistImageUrl == null)
                          ? const CircularProgressIndicator()
                          : Padding(
                            padding: EdgeInsets.only(left: Responsive.isSmallScreen(context) ||  Responsive.isMobile(context) ?10:(Responsive.isMediumScreen(context)?40:60)),
                            child: ListTile(
                                title: Text(artistName!,
                                    style: const TextStyle(color: Colors.white, fontSize: 20)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      artistBio!,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            useSafeArea: true,
                                              context: context,
                                              builder: (context) =>
                                                  SingleChildScrollView(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          gradient: LinearGradient(begin: Alignment.topCenter,
                                                              end: Alignment.bottomCenter,
                                                              colors: [Colors.brown.withOpacity(0.88),
                                                            Colors.black.withOpacity(0.88),
                                                            Colors.black.withOpacity(0.88),
                                                            Colors.black.withOpacity(0.55)
                                                          ])),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 100),
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(height: 40,),
                                                            SizedBox(
                                                              height: 150,
                                                              width: 150,
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(5),
                                                                child:
                                                                    Image.network(
                                                                      artistImageUrl!,
                                                                      fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 30,),
                                                            Text(
                                                              artistName!,
                                                              style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight.bold),
                                                            ),
                                                            const SizedBox(height: 30,),
                                                            Text(
                                                              artistBio!,
                                                              style: const TextStyle(color: Colors.white),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ));
                                        },
                                        child:const Text("Read More",style: TextStyle(color: Colors.blueAccent)))
                                  ],
                                ),
                                trailing: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    artistImageUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            if(Responsive.isMobile())
            const PopOut(),
            if(Responsive.isMobile())
            Positioned(
              top: Responsive.isMobile(context) ? 40 : 20,
              right: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: Responsive.isMobile(context) ?  BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.withOpacity(0.7)
                ):null,
                  child: IconButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Search(backButton: true,)));
                  },
                      icon: Icon(Icons.search, size: 20,color: Colors.white,))),
            )
          ],
        ));
  }
}
