import 'dart:io';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music_player/locator.dart';
import 'package:music_player/services/local_file_service.dart';
import 'package:riverpod/riverpod.dart';

LocalFileService _localFilesLocator = locator<LocalFileService>();

final filesLocatorProvider =
    Provider<LocalFileService>((ref) => _localFilesLocator);

final allMusicFilesProvider =
    FutureProvider.family<List<String>?, String>((ref, String data) async {
  List<String> allFiles =
      await _localFilesLocator.getMusicFiles(onlyMusicFiles: true);
  return allFiles;
});

final currentDirectoryProvider = StateProvider<String>((ref) {
  var dir = ref.watch(filesLocatorProvider);
  return dir.directoryPath;
});

final allFilesProvider = Provider<List<String>>((ref) {
  var _playlist = ref.watch(filesLocatorProvider);
  return _playlist.playlist;
});

final getNameArtistProvider =
    FutureProvider.family<Map<String, dynamic>, String>(
        (ref, String filePath) async {
  Map<String, dynamic> result = {};
  Metadata _metadata = await MetadataRetriever.fromFile(File(filePath));
  result['trackname'] = _metadata.trackName;
  var artistNames = _metadata.trackArtistNames;
  result['artistname'] = artistNames != null ? artistNames[0] : null;
  result['clipart'] = _metadata.albumArt;
  return result;
});
