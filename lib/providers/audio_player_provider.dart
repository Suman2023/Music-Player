import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/locator.dart';
import 'package:music_player/services/audio_player_service.dart';

final player = locator<AudioPlayerService>();

final playerProvider = Provider<AudioPlayerService>((ref) => player);

final playerStateStreamProvider =
    StreamProvider.autoDispose<PlayerState>((ref) async* {
  final player = ref.watch(playerProvider);
  await for (var item in player.player.playerStateStream) {
    yield item;
  }
});

//positionSTream

final currentPositionProvider = StreamProvider<Duration>((ref) async* {
  var currentPlayer = ref.watch(playerProvider);
  await for (Duration duration in currentPlayer.player.positionStream) {
    // double mill = duration.inMilliseconds.toDouble();
    yield duration;
  }
});

//durationStreamar

final currentVolumeStreamProvider = StreamProvider<double>((ref) async* {
  var currentPlayer = ref.watch(playerProvider);
  await for (double volume in currentPlayer.player.volumeStream) {
    yield volume;
  }
});
//indexStream

final currentIndexStreamProvider = StreamProvider<int?>((ref) async* {
  var currentPlayer = ref.watch(playerProvider);

  await for (int? index in currentPlayer.player.currentIndexStream) {
    yield index;
  }
});

//
