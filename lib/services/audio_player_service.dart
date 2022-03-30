// ignore_for_file: avoid_print

import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  final List<AudioSource> _audioSourceList = [];
  var _count = 0;

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

  void play() {
    _count++;
    if (_player.audioSource != null) {
      _player.play();
    } else {
      // _player.play();
      // print(_player.playerState.playing.toString());
      // print("SOmething is wrong");
      _player.stop();
    }
  }

  void playAtIndex(Duration duration, int index) {
    _player.seek(duration, index: index);
  }

  void pause() {
    if (_player.playing) {
      _player.pause();
    }
  }

  void playNext() {
    if (_player.hasNext) {
      _player.seekToNext();
    } else {
      _player.play();
    }
  }

  void playPrevious() {
    if (_player.hasPrevious) {
      _player.seekToPrevious();
    } else {
      _player.play();
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

  void stop() {
    player.stop();
  }
}