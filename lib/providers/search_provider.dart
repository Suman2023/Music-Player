import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/providers/local_files_provider.dart';

final searchTextStateProvider = StateProvider<TextEditingController>(
    (ref) => TextEditingController(text: ""));

final songListStateProvider = FutureProvider.autoDispose
    .family<List<List<dynamic>>, String>((ref, String searchText) async {
  var _filesLocator = ref.watch(filesLocatorProvider);
  var _allMusicfiles = await _filesLocator.getMusicFiles(onlyMusicFiles: true);

  List<List<dynamic>> result = [];
  for (var i = 0; i < _allMusicfiles.length; i++) {
    if (_allMusicfiles[i].toLowerCase().contains(searchText.toLowerCase())) {
      result.add([i, _allMusicfiles[i]]);
    }
  }
  return result;
});
