import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/locator.dart';
import 'package:music_player/services/local_file_service.dart';

class MusicFiles extends StateNotifier<List<String>> {
  MusicFiles([List<String>? files]) : super(files ?? []);

  final LocalFileService _localFileService = locator<LocalFileService>();
  void getAllFiles() async {
    List<String> allFiles = await _localFileService.getMusicFiles();
    state = allFiles;
  }
}
