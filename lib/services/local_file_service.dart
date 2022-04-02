import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/locator.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';

import 'audio_player_service.dart';

class LocalFileService {
  String? _directoryPath;
  List<String> _playlist = [];
  final Box _box = Hive.box("musicplayerdata");

  String get directoryPath {
    if (_box.get("directory") == null) {
      _box.put("directory", "");
    }
    return _box.get("directory");
  }

  Future<List<String>> get playlist async => await _box.get("currentFiles");

  Future<String?> pickFolder() async {
    _directoryPath = await FilePicker.platform.getDirectoryPath();
    if (_directoryPath != null) {
      await _box.put("directory", _directoryPath);
      await _box.put("currentFiles",
          <String>[]); //Empty the current files to refill after dir changes
    }
    await getMusicFiles();
    return _directoryPath;
  }

  Future<List<String>> getMusicFiles({bool onlyMusicFiles = false}) async {
    List<String> cacheFilesList = await _box.get("currentFiles");
    if (cacheFilesList.isEmpty) {
      List<FileSystemEntity> entities =
          await Directory(directoryPath).list(recursive: true).toList();
      _playlist.clear();
      for (var file in entities) {
        if (extension(file.path) == ".mp3") {
          _playlist.add(file.path);
        }
      }
      await _box.put("currentFiles", _playlist);
    } else {
      _playlist = cacheFilesList;
    }
    if (!onlyMusicFiles) {
      await locator<AudioPlayerService>().initialiseSources(_playlist);
    }
    print(_playlist.length);
    return _playlist;
  }
}
