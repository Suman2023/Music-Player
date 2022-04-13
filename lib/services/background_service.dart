import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/locator.dart';
import 'package:music_player/services/audio_player_service.dart';

//

class BackgroundAudioController extends BaseAudioHandler {
  final AudioPlayerService _audioPlayer = locator<AudioPlayerService>();

  BackgroundAudioController() {
    _audioPlayer.player.playbackEventStream
        .map(_transformEvent)
        .pipe(playbackState);
  }

  @override
  Future<void> play() => _audioPlayer.play();

  @override
  Future<void> pause() => _audioPlayer.pause();

  @override
  Future<void> skipToNext() => _audioPlayer.playNext();

  @override
  Future<void> skipToPrevious() => _audioPlayer.playPrevious();

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
    await playbackState.firstWhere(
        (state) => state.processingState == AudioProcessingState.idle);
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_audioPlayer.player.playing)
          MediaControl.pause
        else
          MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_audioPlayer.player.processingState]!,
      playing: _audioPlayer.player.playing,
      updatePosition: _audioPlayer.player.position,
      bufferedPosition: _audioPlayer.player.bufferedPosition,
      speed: _audioPlayer.player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
