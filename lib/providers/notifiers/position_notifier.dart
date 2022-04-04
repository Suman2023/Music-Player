import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:music_player/locator.dart';
import 'package:music_player/services/audio_player_service.dart';

class PositionNotifierProvider extends ChangeNotifier {
  AudioPlayerService _audioplayerLocator = locator<AudioPlayerService>();
  late StreamSubscription<dynamic> _positionStream;

  Duration _currentPostion = Duration(milliseconds: 0);

  Duration get currentPosition => _currentPostion;

  void start() {
    _positionStream = Stream.periodic(
      Duration(seconds: 1),
    ).listen((event) {
      _currentPostion = _audioplayerLocator.player.position;
      notifyListeners();
    });
  }

  void pause() {
    _positionStream.pause();
  }

  void resume() {
    _positionStream.resume();
  }
}
