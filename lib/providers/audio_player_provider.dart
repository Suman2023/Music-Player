import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/locator.dart';
import 'package:music_player/services/audio_player_service.dart';

final player = locator<AudioPlayerService>();

final playerProvider =
    Provider.autoDispose<AudioPlayerService>((ref) => player);

final playerLoopModeProvider =
    StateProvider<LoopMode>((ref) => player.currentLoopMode());

final playerShuffleModeStateProvider =
    StateProvider<bool>((ref) => player.currentShuffleMode());

final playerStateStreamProvider =
    StreamProvider.autoDispose<PlayerState>((ref) async* {
  final player = ref.watch(playerProvider);
  await for (var item in player.player.playerStateStream) {
    yield item;
  }
});

//positionSTream

final currentPositionProvider =
    StreamProvider.autoDispose<Duration>((ref) async* {
  var currentPlayer = ref.watch(playerProvider);
  var stream = currentPlayer.player.createPositionStream(
      minPeriod: const Duration(seconds: 1),
      maxPeriod: const Duration(seconds: 1));
  // print("new stream");

  await for (final duration in stream) {
    // print("called duration");
    yield duration;
  }

  // yield stream.;
});

//durationStreamar

final currentVolumeStreamProvider =
    StreamProvider.autoDispose<double>((ref) async* {
  var currentPlayer = ref.watch(playerProvider);

  await for (double volume in currentPlayer.player.volumeStream) {
    yield volume;
  }
});
//indexStream

final currentIndexStreamProvider =
    StreamProvider.autoDispose<int?>((ref) async* {
  var currentPlayer = ref.watch(playerProvider);

  await for (int? index in currentPlayer.player.currentIndexStream) {
    yield index;
  }
});

//

// final positionProvider = StateProvider.autoDispose<Duration>((ref) {
//   var result;
//   var hello = Stream.periodic(Duration(seconds: 1),).listen((event) {
//     result = player.player.position;
//   });
//   return hello.;
// });

