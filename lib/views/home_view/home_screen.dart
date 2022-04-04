// ignore_for_file: prefer_const_constructors, empty_catches

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/color_pallete/all_colors.dart';
import 'package:music_player/locator.dart';
import 'package:music_player/providers/audio_player_provider.dart';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music_player/providers/local_files_provider.dart';
import 'package:music_player/views/home_view/music_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _colorScheme = locator<AppColorsScheme>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // final playerStateStream = ref.watch(playerStateStreamProvider);
    // final currentIndex = ref.watch(currentIndexStreamProvider);
    final _fileLocator = ref.watch(filesLocatorProvider);
    final _allMusicFilesProvider =
        ref.watch(allFilesProvider(_fileLocator.directoryPath));
    final currentIndex = ref.watch(currentIndexStreamProvider);

    print("Home Screen Rebuilt");

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Center(
            child: IconButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "settings"),
                icon: const FaIcon(FontAwesomeIcons.chevronLeft)),
          ),
          title: GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, 'search'),
              child: Center(child: Text("Music Player"))),
          actions: [
            Center(
              child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "allmusic");
                  },
                  icon: const FaIcon(FontAwesomeIcons.chevronRight)),
            )
          ],
        ),
        body: _allMusicFilesProvider.when(
            data: (allMusicFiles) => Stack(
                  children: [
                    Container(
                      height: height,
                      width: width,
                      // color: Colors.red,
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
                                  final getAlbumArt = ref.watch(
                                      getALbumArtProvider(allMusicFiles[
                                          currentIndex.value ?? 0]));
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
                                  final musicDetails = ref.watch(
                                      getNameArtistProvider(allMusicFiles[
                                          currentIndex.value ?? 0]));
                                  return musicDetails.when(
                                      data: (_data) {
                                        return getTitleWidget(
                                            name:
                                                _data['trackname'] ?? "Unknown",
                                            artist: _data["artistname"] ??
                                                "Unknown");
                                      },
                                      error: (_, __) => getTitleWidget(),
                                      loading: () => getTitleWidget());
                                })
                              : getTitleWidget(),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: height * .45,
                    //   child: SizedBox(
                    //     width: width,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(16.0),
                    //       child: StreamBuilder(
                    //           stream: player.player.positionStream,
                    //           builder: (BuildContext context,
                    //               AsyncSnapshot<Duration> snapshot) {
                    //             return Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               mainAxisSize: MainAxisSize.max,
                    //               children: [
                    //                 Row(
                    //                   children: [
                    //                     FaIcon(
                    //                       FontAwesomeIcons.play,
                    //                       size: 12,
                    //                     ),
                    //                     SizedBox(
                    //                       width: 5,
                    //                     ),
                    //                     // var
                    //                     // return '${duration.inMinutes}m${seconds.toStringAsFixed(2)}s';
                    //                     snapshot.data != null
                    //                         ? Text(snapshot.data
                    //                             .toString()
                    //                             .split('.')[0]
                    //                             .toString())
                    //                         : Text("00:00"),
                    //                   ],
                    //                 ),
                    //                 Text(player.player.duration == null
                    //                     ? "0:00:00"
                    //                     : player.player.duration
                    //                         .toString()
                    //                         .split('.')[0]
                    //                         .toString()),
                    //               ],
                    //             );
                    //           }),

                    // ),
                    // );
                    // ),
                    Positioned(
                        top: height * .45,
                        child: SizedBox(
                          width: width,
                          child: Consumer(builder: (context, ref, child) {
                            final _loopMode =
                                ref.watch(playerLoopModeProvider.state);
                            final _shuffleMode =
                                ref.watch(playerShuffleModeStateProvider.state);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    color: _colorScheme.shuffleReapeatIconColor,
                                    splashRadius: 0.1,
                                    onPressed: () {
                                      player.setLoopMode();
                                      _loopMode.state =
                                          player.currentLoopMode();
                                    },
                                    icon: _loopMode.state == LoopMode.off
                                        ? Icon(Icons.repeat)
                                        : _loopMode.state == LoopMode.one
                                            ? Icon(Icons.repeat_one_on_outlined)
                                            : Icon(Icons.repeat_on_outlined)),
                                IconButton(
                                    color: _colorScheme.shuffleReapeatIconColor,
                                    splashRadius: 0.1,
                                    onPressed: () {
                                      player.setShuffleMode();
                                      _shuffleMode.state =
                                          player.currentShuffleMode();
                                    },
                                    icon: _shuffleMode.state == true
                                        ? Icon(Icons.shuffle_on_outlined)
                                        : Icon(Icons.shuffle)),
                              ],
                            );
                          }),
                        )),

                    Positioned(
                        top: height * .5,
                        left: 0.5 * width - 150,
                        child: MusicController()),
                  ],
                ),
            loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
            error: (e, s) => Center(
                  child: Text(e.toString()),
                )));
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
          style: TextStyle(
              color: _colorScheme.allMusicListSongNameColor,
              fontSize: 18,
              fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          artist,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: TextStyle(color: _colorScheme.allMusicListArtistNameColor),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
