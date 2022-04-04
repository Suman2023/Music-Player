import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/color_pallete/all_colors.dart';
import 'package:music_player/locator.dart';
import 'package:music_player/providers/audio_player_provider.dart';
import 'package:music_player/providers/local_files_provider.dart';
import 'package:music_player/providers/search_provider.dart';
import 'package:music_player/providers/widget_animations_controller.dart';

class SearchScreen extends ConsumerWidget {
  SearchScreen({Key? key}) : super(key: key);
  final _colorScheme = locator<AppColorsScheme>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _searchController = ref.watch(searchTextStateProvider.state);
    var _searchResults =
        ref.watch(songListStateProvider(_searchController.state.text));
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Center(
            child: IconButton(
                onPressed: () => Navigator.pushNamed(context, "home"),
                icon: const FaIcon(FontAwesomeIcons.chevronLeft)),
          ),
          title: TextFormField(
            controller: _searchController.state,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.white),
                hintText: 'Search for the music u love',
                border: InputBorder.none),
            textAlign: TextAlign.center,
            autofocus: true,
            onChanged: (String newVal) {
              print("Searching for " + newVal);
              _searchResults = ref.watch(songListStateProvider(newVal));
            },
            style: TextStyle(color: _colorScheme.searchColor),
          ),
          actions: [
            Center(
              child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "home");
                  },
                  icon: const FaIcon(FontAwesomeIcons.chevronRight)),
            )
          ],
        ),
        body: Container(
          height: height,
          width: width,
          color: _colorScheme.allMusicListViewConatinerColor,
          child: _searchResults.when(
              data: (data) {
                return data.isNotEmpty
                    ? ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) => listItemConsumer(
                            height: 50,
                            file: data[index][1],
                            index: data[index][0]))
                    : const Center(
                        child: Text("Not FOund"),
                      );
              },
              error: (e, s) => const Center(
                  child: Text("There was an error. Pls Try Again!")),
              loading: () => const Center(child: CircularProgressIndicator())),
        ));
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
          ? Text(
              "Unknown",
              overflow: TextOverflow.clip,
              maxLines: 1,
              style: TextStyle(
                  color: _colorScheme.allMusicListSongNameColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )
          : Text(
              trackname,
              overflow: TextOverflow.clip,
              maxLines: 1,
              style: TextStyle(
                  color: _colorScheme.allMusicListSongNameColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              // textAlign: TextAlign.center,
            ),
      subtitle: artistname == null
          ? Text(
              "Unknown",
              overflow: TextOverflow.clip,
              maxLines: 1,
              style: TextStyle(color: _colorScheme.allMusicListArtistNameColor),
            )
          : Text(
              artistname,
              overflow: TextOverflow.clip,
              maxLines: 1,
              style: TextStyle(color: _colorScheme.allMusicListArtistNameColor),
              // textAlign: TextAlign.center,
            ),
      trailing: Consumer(builder: (context, ref, child) {
        final _currentPlayer = ref.watch(playerProvider);
        final _isPlayingState = ref.watch(isPlayingStateProvider.state);
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

              _isPlayingState.state = true;
            }
          },
        );
      }),
    );
  }
}
