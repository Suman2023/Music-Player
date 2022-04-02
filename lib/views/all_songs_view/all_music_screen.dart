import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/providers/audio_player_provider.dart';
import 'package:music_player/providers/local_files_provider.dart';

class AllMusicScreen extends ConsumerWidget {
  const AllMusicScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;

    //
    final _fileLocator = ref.watch(filesLocatorProvider);
    final _allMusicFilesProvider =
        ref.watch(allFilesProvider(_fileLocator.directoryPath));
    print("all music rebuilt");

    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
        leading: Center(
          child: IconButton(
              onPressed: () => Navigator.pushNamed(context, "home"),
              icon: const FaIcon(FontAwesomeIcons.chevronLeft)),
        ),
        title: const Center(child: Text("All Music")),
        actions: [
          Center(
            child: IconButton(
                onPressed: () => Navigator.pushNamed(context, "settings"),
                icon: const FaIcon(FontAwesomeIcons.chevronRight)),
          )
        ],
      ),
      body: _allMusicFilesProvider.when(
          data: (_allMusicFiles) {
            print("running");
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    width: width,
                    // color: Colors.red,
                    child: Consumer(builder: (context, ref, child) {
                      final _currentIndex =
                          ref.watch(currentIndexStreamProvider);
                      return _allMusicFiles.isNotEmpty &&
                              _currentIndex.value != null
                          ? currentlyPlayingWidget(100, width,
                              _allMusicFiles[_currentIndex.value ?? 0])
                          : currentlyPlayingWidget(100, width, "");
                    }),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.red,
                    child: _allMusicFiles.isNotEmpty
                        ? ListView.builder(
                            itemCount: _allMusicFiles.length,
                            itemBuilder: (context, index) {
                              // print(index.toString());
                              return listItemConsumer(
                                  height: 50,
                                  file: _allMusicFiles[index],
                                  index: index);
                            })
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                )
              ],
            );
          },
          loading: () => Center(
                child: CircularProgressIndicator(),
              ),
          error: (e, s) => Center(
              child: Text("Something went wrong try selecting folder agian!"))),
    );
  }

  Widget currentlyPlayingWidget(double height, double width, String file) {
    return Consumer(builder: (context, ref, chhild) {
      final _trackArtistNames = ref.watch(getNameArtistProvider(file));
      return SizedBox(
        height: height,
        width: width,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: _trackArtistNames.when(
              data: (_list) {
                var clipart = _list['clipart'];
                var artistname = _list['artistname'];
                var trackname = _list['trackname'];

                return interiorDesignWidget(height,
                    clipart: clipart,
                    trackname: trackname,
                    artistName: artistname);
              },
              error: (e, s) => interiorDesignWidget(height),
              loading: () => interiorDesignWidget(height)),
        ),
      );
    });
  }

  Row interiorDesignWidget(double height,
      {Uint8List? clipart, String? trackname, String? artistName}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: height,
          width: height,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: clipart == null
                  ? Image.asset(
                      "assets/images/batsy.jpg",
                      fit: BoxFit.fill,
                    )
                  : Image.memory(
                      clipart,
                      fit: BoxFit.fill,
                    )),
        ),
        const SizedBox(
          width: 25,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              trackname == null
                  ? const Text("Unknown")
                  : Text(
                      trackname,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      // textAlign: TextAlign.center,
                    ),
              artistName == null
                  ? const Text("Unknown")
                  : Text(
                      artistName,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      // textAlign: TextAlign.center,
                    ),
            ],
          ),
        ),
        Consumer(builder: (context, ref, child) {
          final _player = ref.watch(playerProvider);
          final _playerStateProvider = ref.watch(playerStateStreamProvider);
          return _playerStateProvider.when(
              data: (_playerState) {
                return _playerState.playing
                    ? IconButton(
                        onPressed: () {
                          _player.pause();
                        },
                        icon: const FaIcon(FontAwesomeIcons.pauseCircle))
                    : IconButton(
                        onPressed: () {
                          _player.play();
                        },
                        icon: const FaIcon(FontAwesomeIcons.playCircle));
              },
              error: (e, s) => IconButton(
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.playCircle)),
              loading: () => const FaIcon(FontAwesomeIcons.playCircle));
        }),
      ],
    );
  }

  Widget listItemConsumer(
      {required double height, required String file, required int index}) {
    return Consumer(
      builder: (context, ref, child) {
        final _trackArtistNames = ref.watch(getNameArtistProvider(file));

        return _trackArtistNames.when(
            data: (_list) {
              var clipart = _list['clipart'];
              var artistname = _list['artistname'];
              var trackname = _list['trackname'];

              return songsListTile(
                  height: height,
                  clipart: clipart,
                  trackname: trackname,
                  artistname: artistname,
                  index: index);
            },
            error: (e, s) => songsListTile(height: height),
            loading: () => songsListTile(height: height));
      },
    );
  }

  Widget songsListTile(
      {required double height,
      Uint8List? clipart,
      String? trackname,
      String? artistname,
      int? index}) {
    return ListTile(
      leading: SizedBox(
        height: height,
        width: height,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: clipart == null
                ? Image.asset(
                    "assets/images/batsy.jpg",
                    fit: BoxFit.fill,
                  )
                : Image.memory(
                    clipart,
                    fit: BoxFit.fill,
                  )),
      ),
      title: trackname == null
          ? const Text("Unknown")
          : Text(
              trackname,
              overflow: TextOverflow.clip,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              // textAlign: TextAlign.center,
            ),
      subtitle: artistname == null
          ? const Text("Unknown")
          : Text(
              artistname,
              overflow: TextOverflow.clip,
              maxLines: 1,
              // textAlign: TextAlign.center,
            ),
      trailing: Consumer(builder: (context, ref, child) {
        final _currentPlayer = ref.watch(playerProvider);
        return PopupMenuButton(
          initialValue: "play",
          itemBuilder: (_) => <PopupMenuItem<String>>[
            const PopupMenuItem(
              child: Text("Play"),
              value: "play",
            ),
            const PopupMenuItem(
              child: Text("Add to playlist"),
              value: "add to playlist",
            )
          ],
          onSelected: (String newVal) {
            if (newVal == "play") {
              _currentPlayer.playAtIndex(
                  const Duration(seconds: 0), index ?? 0);
            }
          },
        );
      }),
    );
  }
}
