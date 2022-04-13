// ignore_for_file: avoid_print

import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  final List<AudioSource> _audioSourceList = [];
  final _count = 0;

  int get count => _count;
  AudioPlayer get player => _player;
  List<AudioSource> get audioSourceList => _audioSourceList;

  // void initPlayer() {
  //   print('Player initialised');
  //   _player = AudioPlayer();
  // }

  // void destroyPlayer() {
  //   _player.dispose();
  //   _player = AudioPlayer();
  // }

  Future<void> initialiseSources(List<String> audioFiles) async {
    //all files collected from the local storage to be pased here as argument

    _audioSourceList.clear();

    for (var audioFile in audioFiles) {
      audioSourceList.add(AudioSource.uri(Uri.parse(audioFile)));
    }
    print("called init of sudio");
    await _player
        .setAudioSource(ConcatenatingAudioSource(children: audioSourceList));
    _player.pause();
  }

  // Future<void> clearAudioSource() async{
  //   await _player.audi
  // }

  Future<void> play() async {
    if (_player.audioSource != null) {
      await _player.play();
    } else {
      // _player.play();
      // print(_player.playerState.playing.toString());
      // print("SOmething is wrong");
      _player.stop();
    }
  }

  Future<void> playAtIndex(Duration duration, int index) async {
    await _player.seek(duration, index: index);
    await _player.play();
  }

  Future<void> pause() async {
    if (_player.playing) {
      await _player.pause();
    }
  }

  Future<void> playNext() async {
    if (_player.hasNext) {
      await _player.seekToNext();
    } else {
      await _player.seek(const Duration(milliseconds: 0),
          index: _player.currentIndex);
      await _player.play();
    }
  }

  Future<void> playPrevious() async {
    if (_player.hasPrevious) {
      await _player.seekToPrevious();
    } else {
      await _player.play();
    }
  }

  void seekToPosition(double position) {
    if (_player.playing) {
      _player.seek(Duration(milliseconds: position.toInt()));
    }
  }

  void changeVolume(String operator) {
    if (operator == '+') {
      _player.setVolume(_player.volume < 0.9 ? _player.volume + 0.1 : 1);
    } else {
      _player.setVolume(_player.volume > 0.1 ? _player.volume - 0.1 : 0);
    }
  }

  int currentIndex() {
    return _player.currentIndex!;
  }

  List<int>? getAllIndices() {
    return _player.effectiveIndices;
  }

  void shuffleIndices() {
    _player.shuffle();
  }

  void setLoopMode() {
    if (_player.loopMode == LoopMode.all) {
      _player.setLoopMode(LoopMode.off);
    } else if (_player.loopMode == LoopMode.one) {
      _player.setLoopMode(LoopMode.all);
    } else {
      _player.setLoopMode(LoopMode.one);
    }
  }

  LoopMode currentLoopMode() {
    return _player.loopMode;
  }

  void setShuffleMode() {
    if (_player.shuffleModeEnabled) {
      _player.setShuffleModeEnabled(false);
    } else {
      _player.setShuffleModeEnabled(true);
    }
  }

  bool currentShuffleMode() {
    return _player.shuffleModeEnabled;
  }

  Future<void> stop() async {
    await player.stop();
  }
}
