// ignore_for_file: prefer_const_constructors, empty_catches

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/providers/audio_player_provider.dart';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music_player/providers/local_files_provider.dart';
import 'package:music_player/views/home_view/music_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // final playerStateStream = ref.watch(playerStateStreamProvider);
    // final currentIndex = ref.watch(currentIndexStreamProvider);
    final allMusicFiles = ref.watch(allFilesProvider);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.red,
          leading: Center(
            child: IconButton(
                onPressed: () => Navigator.pushNamed(context, "settings"),
                icon: const FaIcon(FontAwesomeIcons.chevronLeft)),
          ),
          title: const Center(child: Text("Music Player")),
          actions: [
            Center(
              child: IconButton(
                  onPressed: () => Navigator.pushNamed(context, "allmusic"),
                  icon: const FaIcon(FontAwesomeIcons.chevronRight)),
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
              height: height,
              width: width,
              color: Colors.red,
            ),
            Positioned(
              top: 10,
              left: width * .175,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  height: height * .35,
                  width: width * .65,
                  // color: Colors.green,
                  child: allMusicFiles.isNotEmpty
                      ? Consumer(builder: (context, ref, child) {
                          final currentIndex =
                              ref.watch(currentIndexStreamProvider);
                          final getAlbumArt = ref.watch(getALbumArtProvider(
                              allMusicFiles[currentIndex.value ?? 0]));
                          return getAlbumArt.when(
                              data: (_data) {
                                return _data != null
                                    ? Image.memory(
                                        _data,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.asset(
                                        "assets/images/batsy.jpg",
                                        fit: BoxFit.fill,
                                      );
                              },
                              error: (e, s) => Image.asset(
                                    "assets/images/batsy.jpg",
                                    fit: BoxFit.fill,
                                  ),
                              loading: () => Image.asset(
                                    "assets/images/batsy.jpg",
                                    fit: BoxFit.fill,
                                  ));
                        })
                      : Image.asset(
                          "assets/images/batsy.jpg",
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ),
            Positioned(
              top: height * .35 + 10,
              left: width * .175,
              child: Container(
                width: width * .65,
                color: Colors.transparent,
                child: Center(
                  child: allMusicFiles.isNotEmpty
                      ? Consumer(builder: (context, ref, child) {
                          final currentIndex =
                              ref.watch(currentIndexStreamProvider);
                          final musicDetails = ref.watch(getNameArtistProvider(
                              allMusicFiles[currentIndex.value ?? 0]));
                          return musicDetails.when(
                              data: (_data) {
                                return getTitleWidget(
                                    name: _data['trackname'] ?? "Unknown",
                                    artist: _data["artistname"] ?? "Unknown");
                              },
                              error: (_, __) => getTitleWidget(),
                              loading: () => getTitleWidget());
                        })
                      : getTitleWidget(),
                ),
              ),
            ),
            Positioned(
              top: height * .45,
              child: SizedBox(
                width: width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer(builder: (context, currentRef, child) {
                    final positionStream =
                        currentRef.watch(currentPositionProvider);
                    final _playerState = ref.watch(playerStateStreamProvider);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.play,
                              size: 12,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            // var
                            // return '${duration.inMinutes}m${seconds.toStringAsFixed(2)}s';
                            positionStream.when(
                                data: (_position) {
                                  // Duration duration = Duration(
                                  //     milliseconds: _position.toInt());
                                  // ;
                                  return Text(_position
                                      .toString()
                                      .split('.')[0]
                                      .toString());
                                },
                                error: (_, __) => Text("00:00"),
                                loading: () => Text("00:00"))
                          ],
                        ),
                        Text(player.player.duration == null
                            ? "0:00:00"
                            : player.player.duration
                                .toString()
                                .split('.')[0]
                                .toString()),
                      ],
                    );
                  }),
                ),
              ),
            ),
            Positioned(
                top: height * .5,
                left: 0.5 * width - 150,
                child: MusicController()),
          ],
        ));
    // error: (e, s) => Text(e.toString()),
    // loading: () => CircularProgressIndicator()));
  }

  Widget getTitleWidget({String name = "Unknown", String artist = "Unknown"}) {
    name = name.split('-')[0];
    name = name.split('(')[0];
    name = name.split('|')[0];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          artist,
          maxLines: 1,
          overflow: TextOverflow.clip,
        ),
      ],
    );
  }
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _player.dispose();
  // }
}
