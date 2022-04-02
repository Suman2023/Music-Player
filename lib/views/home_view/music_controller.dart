import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/providers/audio_player_provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MusicController extends ConsumerWidget {
  const MusicController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    //
    final player = ref.watch(playerProvider);
    final currentVolume = ref.watch(currentVolumeStreamProvider);

    print("Music COntroller rebuilt");
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150), color: Colors.blueAccent),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              height: 300 / 2,
              width: 300 / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                color: Colors.blueGrey,
              )),
          Container(
            height: 150 / 2,
            width: 150 / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: Colors.green,
            ),
            // child:
          ),
          Consumer(builder: (context, ref, child) {
            final _duration = ref.watch(currentPositionProvider);
            print(_duration.value ?? "");
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
              print("music controller");
              return playerState.when(
                  data: (_data) {
                    return _data.playing
                        ? IconButton(
                            onPressed: () {
                              player.pause();
                            },
                            icon: const Icon(Icons.pause))
                        : _data.processingState != ProcessingState.completed
                            ? IconButton(
                                onPressed: () {
                                  player.player.play();
                                },
                                icon: const Icon(Icons.play_arrow))
                            : IconButton(
                                onPressed: () {
                                  player.player.play();
                                },
                                icon: const Icon(Icons.replay));
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
