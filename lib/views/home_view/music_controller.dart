import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/color_pallete/all_colors.dart';
import 'package:music_player/locator.dart';
import 'package:music_player/providers/audio_player_provider.dart';
import 'package:music_player/providers/widget_animations_controller.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MusicController extends ConsumerStatefulWidget {
  const MusicController({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MusicControllerState();
}

class _MusicControllerState extends ConsumerState<MusicController>
    with TickerProviderStateMixin {
  late AnimationController _playPauseController;

  final _colorScheme = locator<AppColorsScheme>();
  @override
  void initState() {
    super.initState();
    _playPauseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    ref.read(isPlayingStateProvider.state).state
        ? _playPauseController.forward()
        : _playPauseController.reverse();
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    final player = ref.watch(playerProvider);
    final currentVolume = ref.watch(currentVolumeStreamProvider);

    print("Music COntroller rebuilt");
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          color: _colorScheme.outerCircleColor),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              height: 300 / 2,
              width: 300 / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                color: _colorScheme.midCircleColor,
              )),
          Container(
            height: 150 / 2,
            width: 150 / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: _colorScheme.innerrCircleColor,
            ),
            // child:
          ),
          Consumer(builder: (context, ref, child) {
            final _duration = ref.watch(currentPositionProvider);
            print(_duration.value ?? "");
            print("consumer");
            return SleekCircularSlider(
                initialValue: _duration.value == null
                    ? 0.0
                    : _duration.value!.inMilliseconds.toDouble(),
                // initialValue: 0.0,
                min: 0.0,
                max: player.player.duration != null
                    ? player.player.duration!.inMilliseconds.toDouble()
                    : 100,
                appearance: CircularSliderAppearance(
                  customWidths: CustomSliderWidths(
                    handlerSize: 5,
                    trackWidth: 0,
                    progressBarWidth: 5,
                    shadowWidth: 0,
                  ),
                  customColors: CustomSliderColors(
                      trackColor: Colors.transparent, dotColor: Colors.yellow),
                  size: 300,
                  startAngle: 0,
                  angleRange: 360,
                ),
                innerWidget: (hello) => Container(),
                onChangeEnd: (newPos) {
                  // player.player
                  //   .seek(Duration(milliseconds: newPos.toInt()));
                  player.seekToPosition(newPos);
                });
          }),
          currentVolume.when(
              data: (_volume) => SleekCircularSlider(
                    initialValue: _volume,
                    min: Duration.zero.inMilliseconds.toDouble(),
                    max: 1.001,
                    appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(
                        handlerSize: 0,
                        trackWidth: 0,
                        progressBarWidth: 5,
                        shadowWidth: 0,
                      ),
                      customColors: CustomSliderColors(
                          trackColor: Colors.transparent,
                          dotColor: Colors.yellow),
                      size: 150,
                      startAngle: 0,
                      angleRange: 360,
                    ),
                    innerWidget: (hello) => Container(),
                  ),
              error: (_, __) => SleekCircularSlider(
                    initialValue: 1.001,
                    min: Duration.zero.inMilliseconds.toDouble(),
                    max: 1.001,
                    appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(
                        handlerSize: 0,
                        trackWidth: 0,
                        progressBarWidth: 5,
                        shadowWidth: 0,
                      ),
                      customColors: CustomSliderColors(
                          trackColor: Colors.transparent,
                          dotColor: Colors.yellow),
                      size: 150,
                      startAngle: 0,
                      angleRange: 360,
                    ),
                    innerWidget: (hello) => Container(),
                  ),
              loading: () => SleekCircularSlider(
                    initialValue: 1.001,
                    min: Duration.zero.inMilliseconds.toDouble(),
                    max: 1.001,
                    appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(
                        handlerSize: 0,
                        trackWidth: 0,
                        progressBarWidth: 5,
                        shadowWidth: 0,
                      ),
                      customColors: CustomSliderColors(
                          trackColor: Colors.transparent,
                          dotColor: Colors.yellow),
                      size: 150,
                      startAngle: 0,
                      angleRange: 360,
                    ),
                    innerWidget: (hello) => Container(),
                  )),
          Consumer(
            builder: (context, ref, child) {
              final playerState = ref.watch(playerStateStreamProvider);
              final _isPlayingState = ref.watch(isPlayingStateProvider.state);
              print("music controller");
              return playerState.when(
                  data: (_data) {
                    return IconButton(
                      color: _colorScheme.songControllerColor,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _data.playing
                            ? {
                                _playPauseController.reverse(),
                                player.pause(),
                                _isPlayingState.state = false,
                              }
                            : {
                                _playPauseController.forward(),
                                player.play(),
                                _isPlayingState.state = true,
                              };
                      },
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: _playPauseController,
                        size: 36,
                      ),
                    );
                  },
                  error: (e, _) => IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () {},
                      ),
                  loading: () => const CircularProgressIndicator());
            },
          ),
          Positioned(
            top: 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                  color: _colorScheme.songControllerColor,
                  onPressed: () {
                    player.changeVolume('+');
                    player.shuffleIndices();
                  },
                  icon: const FaIcon(FontAwesomeIcons.plus)),
            ),
          ),
          Positioned(
            left: 10,
            child: Container(
                // height: 10,
                // width: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  color: _colorScheme.songControllerColor,
                  onPressed: () {
                    player.playPrevious();
                  },
                  icon: const FaIcon(FontAwesomeIcons.stepBackward),
                )),
          ),
          Positioned(
            right: 10,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  color: _colorScheme.songControllerColor,
                  onPressed: () {
                    player.playNext();
                  },
                  icon: const FaIcon(FontAwesomeIcons.stepForward),
                )),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                  color: _colorScheme.songControllerColor,
                  onPressed: () {
                    player.changeVolume('-');
                  },
                  icon: const FaIcon(FontAwesomeIcons.minus)),
            ),
          ),
        ],
      ),
    );
  }
}
